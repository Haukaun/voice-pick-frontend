//
//  VoiceService.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 24/03/2023.
//

import Foundation
import Speech

enum VoiceAuthorization {
	case AUTHORIZED
	case DENIED
	case RESTRICTED
	case NOT_DETERMINED
	case NOT_AUTHORIZED
}

class VoiceService: ObservableObject {
	
	@Published var isVoiceActive = false
	@Published var isVoiceAuthorized = VoiceAuthorization.NOT_AUTHORIZED
	@Published var transcription = ""
	
	let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
	var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
	var recognitionTask: SFSpeechRecognitionTask?
	let audioEngine = AVAudioEngine()
	
	/**
	 Requests authorization for speech recognition and handles the different possible authorization statuses.
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
	 Starts listing to user inputs
	 */
	func startRecording() {
		recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
		
		//On-device recognition, check if device supports it.
		if #available(iOS 13, *) {
			if speechRecognizer.supportsOnDeviceRecognition {
				recognitionRequest?.requiresOnDeviceRecognition = true
			}
		}
		
		guard let recognitionRequest = recognitionRequest else { return }
		
		let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        recognitionRequest.contextualStrings = ["start" , "repeat", "cancel", "next", "help", "complete", "back", "one", "two", "three"]
		numbers.forEach { number in
			recognitionRequest.contextualStrings.append(number)
		}
				
		let inputNode = audioEngine.inputNode
		let recordingFormat = inputNode.outputFormat(forBus: 0)
		inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
			recognitionRequest.append(buffer)
		}
		
		audioEngine.prepare()
		do {
			try audioEngine.start()
			isVoiceActive = true
		} catch {
			print("Error starting audio engine: \(error.localizedDescription)")
			return
		}
		
		speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
			
			if let result = result {
				let bestTranscription = result.bestTranscription
				var words = bestTranscription.segments.map { $0.substring }
				if (words.count > 0) {
					words[0] = words[0].lowercased()
				}
				let filteredWords = words.filter { recognitionRequest.contextualStrings.contains($0) == true }
				
				var result = ""
				if (filteredWords.contains{ numbers.contains($0) }) {
					// If a number was spoken, include the tree last spoken digits
					if (filteredWords.count == 3) {
						let lastThreeDigits = Array(filteredWords.suffix(3))
						result = lastThreeDigits.joined(separator: "")
					} else {
						result = filteredWords.last ?? ""
					}
				} else {
					// If not, only include the last spoken word in the transcription
					result = filteredWords.last ?? ""
				}
				
				DispatchQueue.main.async {
					// Set the transcription to the new word, or an empty string if no new word was recognized
					self.transcription = result
				}
			} else if let error = error {
				// TODO: handle error correctly
				print("Error recognizing speech: \(error.localizedDescription)")
			}
		}
	}
	
	/**
	 Stops recording and ends recognition task.
	 */
	func stopRecording() {
		recognitionTask?.finish()
		recognitionTask = nil
		recognitionRequest?.endAudio()
		recognitionRequest = nil
		audioEngine.stop()
		audioEngine.inputNode.removeTap(onBus: 0)
		isVoiceActive = false
	}
	
}
