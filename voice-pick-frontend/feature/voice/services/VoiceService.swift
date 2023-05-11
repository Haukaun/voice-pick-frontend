//
//  VoiceService.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 24/03/2023.
//

import Foundation
import Speech
import OSLog

enum VoiceAuthorization {
	case AUTHORIZED
	case DENIED
	case RESTRICTED
	case NOT_DETERMINED
	case NOT_AUTHORIZED
}

class VoiceService: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    
    private let RECOGNIZTION_DEBOUNCE_TIMER = 0.5
	
	@Published var isVoiceAuthorized = VoiceAuthorization.NOT_AUTHORIZED
	
	var onRecognizedTextChange: ((String) -> Void)?
	
	static let shared = VoiceService()
	
	private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
	private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
	private var recognitionTask: SFSpeechRecognitionTask?
	private let audioEngine = AVAudioEngine()
	private let audioSession = AVAudioSession.sharedInstance()
	private let speechSynthesizer = AVSpeechSynthesizer()
	private var recognitionTimer: Timer?
	
	var muted = false
	
	let keywords = Set(["start" , "repeat", "next", "help", "cancel", "complete", "back", "mute", "listen", "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"])
	let mutedKeywords = Set(["cancel"])
	
	override init() {
		super.init()
		speechRecognizer?.delegate = self
		configureAudioSession()
	}
	
	/**
	 Configures the audio session
	 */
	private func configureAudioSession() {
		do {
			if isBluetoothConnected() {
				try audioSession.setCategory(.playAndRecord, mode: .default, options: [.allowBluetoothA2DP, .allowBluetooth, .mixWithOthers])
			} else {
				try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers])
			}
			try audioSession.setActive(true)
		} catch {
			os_log("Error with confiuring the audio device", type: .error)
		}
	}
	
	/**
	 Checks if any bluetooth devices are connected
	 */
	private func isBluetoothConnected() -> Bool {
		let routes = audioSession.currentRoute
		for output in routes.outputs {
			if output.portType == .bluetoothA2DP || output.portType == .bluetoothLE || output.portType == .bluetoothHFP {
				return true
			}
		}
		return false
	}
	
	/**
	 Request the user to allow the application to use the devices microphone and speaker
	 */
	func requestSpeechAuthorization() {
		SFSpeechRecognizer.requestAuthorization { status in
			DispatchQueue.main.async {
				switch status {
				case .authorized:
					self.isVoiceAuthorized = VoiceAuthorization.AUTHORIZED
					print("Speech recognition authorized")
				case .denied:
					self.isVoiceAuthorized = VoiceAuthorization.DENIED
					print("User denied access to speech recognition")
				case .restricted:
					self.isVoiceAuthorized = VoiceAuthorization.RESTRICTED
					print("Speech recognition restricted on this device")
				case .notDetermined:
					self.isVoiceAuthorized = VoiceAuthorization.NOT_DETERMINED
					print("Speech recognition not yet authorized")
				default:
					self.isVoiceAuthorized = VoiceAuthorization.NOT_AUTHORIZED
					print("Speech recognition not authorized")
				}
			}
		}
	}
	
	/**
	 Starts recording voice input
	 */
	func startRecording() {
		if audioEngine.isRunning {
			stopRecording()
		} else {
			
			recognitionRequest?.endAudio()
			recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
			guard let recognitionRequest = recognitionRequest else { return }
			
			if #available(iOS 13, *) {
				if speechRecognizer!.supportsOnDeviceRecognition {
					recognitionRequest.requiresOnDeviceRecognition = true
				}
			}
			
			let inputNode = audioEngine.inputNode
			recognitionTask?.cancel()
			recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
				if let result = result {
					DispatchQueue.main.async {
						self.processRecognitionResult(result.bestTranscription.formattedString)
					}
				}
			}
			
			let recordingFormat = inputNode.outputFormat(forBus: 0)
			inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
				recognitionRequest.append(buffer)
			}
			
			audioEngine.prepare()
			do {
				try audioEngine.start()
			} catch {
				os_log("Error with starting autio engine", type: .error)
			}
		}
	}
	
	/**
	 Stops recoring
	 */
	func stopRecording() {
		audioEngine.stop()
		audioEngine.inputNode.removeTap(onBus: 0)
		recognitionRequest?.endAudio()
		recognitionTask?.cancel()
		recognitionRequest = nil
		recognitionTask = nil
	}
	
	/**
	 Processes the result gotten from the recognizer
	 
	 - Parameters:
	 - result: a string to be processed
	 */
	func processRecognitionResult(_ result: String) {
		recognitionTimer?.invalidate()
		// debounces recognition X seconds
		recognitionTimer = Timer.scheduledTimer(withTimeInterval: RECOGNIZTION_DEBOUNCE_TIMER, repeats: false) { [weak self] _ in
			guard let self = self else { return }
			// Refresh the value stored in the published value
			let result = self.filterKeywordsAndNumbers(from: result)
			self.onRecognizedTextChange?(result)
			// Reset the recognition task so it will start from empty state
			self.stopRecording()
			self.startRecording()
		}
	}
	
	/**
	 Returns a filtered string based on the keywords definined and numbers
	 
	 - Parameters:
	 - text: the string to be filtered
	 
	 - Returns: A filtered string
	 */
	func filterKeywordsAndNumbers(from text: String) -> String {
		let words = text.lowercased().split(separator: " ").map(String.init)
		if self.muted {
			return words.filter { mutedKeywords.contains($0) }.joined(separator: " ").lowercased()
		}
		return words.filter { keywords.contains($0) || isNumber(word: $0) }.joined(separator: " ").lowercased()
	}
	
	/**
	 Checks is a string is a number
	 
	 - Parameters:
	 - word: the string to check
	 
	 - Returns: `true` if the string is a number, `false` otherwise
	 */
	func isNumber(word: String) -> Bool {
		return Int(word) != nil
	}
}
