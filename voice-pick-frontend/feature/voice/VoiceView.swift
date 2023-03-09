//
//  VoiceView.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 09/03/2023.
//

import SwiftUI
import Speech

struct VoiceView<Content: View>: View {
	
	//hold the transcripted message
	@State var transcription = ""
	
	let onChange: (String) -> Void
	var content: Content
	
	//Variables for speech initilizing
	let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
	@State var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
	@State var recognitionTask: SFSpeechRecognitionTask?
	let audioEngine = AVAudioEngine()
	
	init(onChange: @escaping (String) -> Void, @ViewBuilder content: () -> Content) {
		self.onChange = onChange
		self.content = content()
	}
	
	/**
	 Requests authorization for speech recognition and handles the different possible authorization statuses.
	 **/
	func requestSpeechAuthorization() {
		SFSpeechRecognizer.requestAuthorization { status in
			DispatchQueue.main.async {
				switch status {
				case .authorized:
					print("Speech recognition authorized")
				case .denied:
					print("User denied access to speech recognition")
				case .restricted:
					print("Speech recognition restricted on this device")
				case .notDetermined:
					print("Speech recognition not yet authorized")
				default:
					print("Speech recognition not authorized")
				}
			}
		}
	}
	
	/**
	 Starts listing to user inputs.
	 **/
	func startRecording() {
		recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
		
		//On-device recognition, check if device supports it.
		if #available(iOS 13, *) {
			if speechRecognizer.supportsOnDeviceRecognition {
				recognitionRequest?.requiresOnDeviceRecognition = true
			}
		}
		
		guard let recognitionRequest = recognitionRequest else { return }
		recognitionRequest.contextualStrings = ["start" , "repeat", "next", "help", "plukk"]
		
		let inputNode = audioEngine.inputNode
		let recordingFormat = inputNode.outputFormat(forBus: 0)
		inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
			recognitionRequest.append(buffer)
		}
		
		audioEngine.prepare()
		do {
			try audioEngine.start()
		} catch {
			print("Error starting audio engine: \(error.localizedDescription)")
			return
		}
		
		speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
			
			if let result = result {
				let bestTranscription = result.bestTranscription
				let words = bestTranscription.segments.map { $0.substring }
				let filteredWords = words.filter { recognitionRequest.contextualStrings.contains($0) == true }
				let transcription = filteredWords.last // Only include the last spoken word in the transcription
				
				DispatchQueue.main.async {
					// Set the transcription to the new word, or an empty string if no new word was recognized
					self.transcription = transcription ?? ""
				}
			} else if let error = error {
				print("Error recognizing speech: \(error.localizedDescription)")
			}
		}
	}
	
	
	var body: some View {
		VStack{
			content
		}
		.onChange(of: transcription){ newValue in
			self.onChange(newValue)
		}
		.onAppear{
			requestSpeechAuthorization()
			startRecording()
		}
	}
	
}

struct VoiceView_Previews: PreviewProvider {
	static func whatever(_ newvalue: String) -> Void {
		print(newvalue)
	}
	
	static var previews: some View {
		VoiceView(onChange: whatever) {
			PluckPage()
		}
	}
}
