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
            os_log("Error with starting audio engine", type: .error)
            return
        }
        
        speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            
            guard let result = result, error == nil else {
                os_log("Error recognizing speech", type: .error)
                return
            }
            
            let words = result.bestTranscription.formattedString.lowercased()
            
            if let number = Int(words) {
                DispatchQueue.main.async {
                    self.transcription = String(number)
                }
            } else {
                let allowedKeywords: Set<String> = ["start" , "repeat", "next", "help", "cancel", "complete", "back", "mute", "listen", "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
                let filteredWords = words.components(separatedBy: " ").filter { allowedKeywords.contains($0) }
                
                DispatchQueue.main.async {
                    self.transcription = filteredWords.last ?? ""
                }
            }
            
            // TODO: Look into if it's possible to clear the result
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
