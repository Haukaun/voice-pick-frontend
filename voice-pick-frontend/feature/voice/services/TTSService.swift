//
//  TTSService.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 11/04/2023.
//

import Foundation
import AVFAudio


class TTSService: ObservableObject {
	private var speechSynthesizer = AVSpeechSynthesizer()
	@Published var selectedVoice: Voice?
	
	init(selectedVoice: Voice? = nil){
		self.selectedVoice = selectedVoice
	}
	
	/**
	 Plays a string to the device audio output
	 
	 - Parameters:
	 - utterance: the string to be played to the speaker
	 - fromVoice: a boolean discribing if commands where given via voice or touch.
	 If they were given through voice, the utterance is played on the speakers.
	 If the commands are given through touch, the utterance is not played on the speakers
	 */
	func speak(_ utterance: String, _ fromVoice: Bool) {
		if (fromVoice) {
			let speechUtterance = AVSpeechUtterance(string: utterance)
			speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2
			
			
			if (selectedVoice == nil) {
				speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
			} else {
				speechUtterance.voice = AVSpeechSynthesisVoice(identifier: selectedVoice!.rawValue)
			}
			
			speechUtterance.volume = 1.0
			speechUtterance.pitchMultiplier = 1.0
			
			speechSynthesizer.speak(speechUtterance)
		}
	}
    
    /*
     Stop the speaking midsentence
     */
    func stopSpeak() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
	
	/*
	 Set Voice
	 */
	func setVoice(voice: Voice){
		DispatchQueue.main.async {
			self.selectedVoice = voice
		}
	}
	
	
}
