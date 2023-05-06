//
//  TTSService.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 11/04/2023.
//

import Foundation
import AVFAudio


class TTSService: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
	
	// Singleton
	static let shared = TTSService()
	
	private let voiceLog = VoiceLog.shared
	
	private let voiceService = VoiceService.shared
	
	private let synthesizer = AVSpeechSynthesizer()
	
	@Published var selectedVoice: Voice?
	@Published var volume: Float = 0.5
	@Published var rate: Float = 0.5
	
	override init() {
		super.init()
		synthesizer.delegate = self
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
			voiceService.muted = true
			let speechUtterance = AVSpeechUtterance(string: utterance)
			speechUtterance.rate = self.rate
			
			
			if (selectedVoice == nil) {
				speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
			} else {
				speechUtterance.voice = AVSpeechSynthesisVoice(identifier: selectedVoice!.rawValue)
			}
			
			speechUtterance.volume = self.volume
			speechUtterance.pitchMultiplier = 1.0
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.voiceLog.addMessage(LogMessage(message: utterance, type: LogMessageType.OUTPUT))
			}
			synthesizer.speak(speechUtterance)
		}
	}
	
	/**
		Mutes the voice recognition everytime the utterance is speaking.
	 */
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
		voiceService.muted = true
	}
	
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
		voiceService.muted = false
	}
	
	/*
	 Stop the speaking midsentence
	 */
	func stopSpeak() {
		synthesizer.stopSpeaking(at: .immediate)
		voiceService.muted = false
	}
	
	
	/**
	 Set volume
	 */
	func setVolume(volume: Float) {
		self.volume = volume
	}
	
	/**
	 Get volume
	 */
	func getVolume() -> Float {
		return self.volume
	}
	
	/**
	 Set speed of voice
	 */
	func setRate(rate: Float) {
		self.rate = rate
	}
	
	/**
	 Get speed of voice
	 */
	func getRate() -> Float {
		return self.rate
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
