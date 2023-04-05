//
//  PluckPageViewModel.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 17/03/2023.
//

import Foundation
import SwiftUI
import Combine
import AVFAudio

enum Steps {
	case START
	case SELECT_CARGO
	case PLUCK
	case DELIVERY
}

class PluckService: ObservableObject {
	@Published var currentStep: Steps = .START
	@Published var activePage: PluckPages = .LOBBY
	@Published var pluckList: PluckList?
	@Published var cargoCarriers: [CargoCarrier] = []
	@Published var requestService = RequestService()
	
	
	let audioSession: AVAudioSession
	let speechSynthesizer = AVSpeechSynthesizer()
	init() {
		audioSession = AVAudioSession.sharedInstance()
		do {
			// TODO: Check if bluetooth. If yes set category to this:
			try audioSession.setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth, .allowBluetoothA2DP])
			// if not, set category to this:
			// try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
		} catch let error as NSError {
			print("Error: \(error.localizedDescription)")
		}
	}
	
	/**
	 A function that handles action made either through the UI or through voice
	 
	 - Parameters:
	 - keyword: a keyword describing the action that was made
	 - fromVoice: a boolean describing if the action was made via coide. `true` if yes, `false` otherwise
	 */
	func doAction(keyword: String, fromVoice: Bool, token: String? = nil) {
		// TODO: Remove prints when error handling is complete
		print("Active page: \(self.activePage)")
		print("Current step: \(self.currentStep)")
		print("Keyword: \(keyword)")
		
		switch currentStep {
		case .START:
			handleStartActions(keyword, fromVoice, token)
			break
		case .SELECT_CARGO:
			handleCargoAction(keyword, fromVoice)
			break
		case .PLUCK:
			handlePluckAction(keyword, fromVoice)
			break
		case .DELIVERY:
			handleDeliveryAction(keyword, fromVoice)
			break
		}
	}
	
	/**
	 Handles all actions available from start page
	 
	 - Parameters:
	 - keyword: the keyword of the action to make
	 - fromVoice: a boolean describing if the action was made via voice. `true` if yes, `false` otherwise
	 */
	private func handleStartActions(_ keyword: String, _ fromVoice: Bool, _ token: String?) {
		switch keyword {
		case "start":
			initializePlucklist(fromVoice, token!)
			break
		case "repeat":
			speak("Say 'start' to start a new pluck order", fromVoice)
		case "help":
			speak("You only have one option: 'start' to start a new pluck order", fromVoice)
		default:
			return
		}
	}
	
	/**
	 Initializes a new plucklist
	 */
	private func initializePlucklist(_ fromVoice: Bool, _ token: String) {
		requestService.get(path: "/plucks", header: token, responseType: PluckList.self, completion: { [self] result in
			switch result {
			case .success(let pluckList):
				setPluckList(pluckList)
				setCurrentStep(.SELECT_CARGO)
				updateActivePage(.INFO)
				speak("Select cargo carrier before continuing", fromVoice)
			case .failure(let error):
				print(error)
			}
		})
	}
	
	/**
	 Handles all actions available from select cargo step
	 
	 - Parameters:
	 - keyword: the keyword of the action to make
	 - fromVoice: a boolean describing if the action was made via voice. `true` if yes, `false` otherwise
	 */
	private func handleCargoAction(_ keyword: String, _ fromVoice: Bool) {
		switch keyword {
		case "help":
			for cargoCarrier in cargoCarriers {
				speak("Say \(cargoCarrier.phoneticIdentifier) for \(cargoCarrier.name)", fromVoice )
			}
			speak("Say 'next' after selecting cargo carrier to continue", fromVoice)
			break
		case "repeat":
			speak("Select a cargo carrier to continue.", fromVoice)
		case "next":
			if (pluckList?.cargoCarrier == nil) {
				speak("Need to select a cargo carrier", fromVoice)
			} else {
				setCurrentStep(.PLUCK)
				updateActivePage(.LIST_VIEW)
				if let index = pluckList?.plucks.firstIndex(where: { $0.pluckedAt == nil }) {
					speak("\(pluckList?.plucks[index].product.location.code ?? "")", fromVoice)
					
				}
				
			}
		default:
			let found = cargoCarriers.first(where: {$0.phoneticIdentifier == keyword})
			if (found != nil) {
				pluckList?.cargoCarrier = found
				speak("\(found!.name) selected", fromVoice)
			} else {
				if (pluckList?.cargoCarrier != nil) {
					speak("Say 'next' to continue", fromVoice)
				} else {
					speak("Need to select a cargo carrier.", fromVoice)
				}
			}
		}
	}
	
	private func handlePluckAction(_ keyword: String, _ fromVoice: Bool) {
		if let keywordInt = isControlDigits(keyword) {
			// Control digits entered
			let index = pluckList?.plucks.firstIndex(where: { $0.confirmedAt == nil })
			
			guard let index = index else {
				print("Could not find pluck")
				return
			}
			
			// Check if control digits is correct
			if (keywordInt == pluckList?.plucks[index].product.location.controlDigits) {
				// Updated confirmed at for the pluck
				
				pluckList?.plucks[index].confirmedAt = Date()
			} else {
				// Wrong control digits
				speak("Wrong control digits. Try again", fromVoice)
			}
		} else {
			// No control digits entered
			switch keyword {
			case "help":
				speak("Confirm control digit, then say 'complete' to complete the pluck", fromVoice)
			case "repeat":
				let index = pluckList?.plucks.firstIndex(where: { $0.confirmedAt == nil })
				
				guard let index = index else {
					return
				}
				
				// Repeat location
				speak("\(pluckList?.plucks[index].product.location.code ?? "")", fromVoice)
			case "complete":
				let index = pluckList?.plucks.firstIndex(where: { $0.pluckedAt == nil })
				
				guard let index = index else {
					return
				}
				
				if (pluckList?.plucks[index].confirmedAt != nil) {
					
					pluckList?.plucks[index].pluckedAt = Date()
					
					// If every pluck is completed
					if (pluckList?.plucks.filter{ $0.pluckedAt == nil }.count == 0) {
						updateActivePage(.COMPLETE)
						speak("All plucks completed", fromVoice)
						DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
							DispatchQueue.main.async { [self] in
								self.updateActivePage(.DELIVERY)
								self.setCurrentStep(.DELIVERY)
							}
						}
					}
				} else {
					speak("Need to confirm pluck first", fromVoice)
				}
			case "back":
				setCurrentStep(.SELECT_CARGO)
				updateActivePage(.INFO)
				speak("Select cargo", fromVoice)
			default:
				return
			}
		}
	}
	
	private func handleDeliveryAction(_ keyword: String, _ fromVoice: Bool) {
		if let keywordInt = isControlDigits(keyword) {
			if (keywordInt == pluckList?.location.controlDigits) {
				pluckList?.confirmedAt = Date()
				speak("Say 'complete' to finish pluck", fromVoice)
			} else {
				speak("Wrong control digits. Try again", fromVoice)
			}
		} else {
			switch keyword {
			case "repeat":
				speak("Confirm control digit, then say 'complete' to finish the pluck", fromVoice)
			case "help":
				speak("Confirm control digit, then say 'complete' to finish the pluck", fromVoice)
			case "complete":
				if (pluckList?.confirmedAt == nil) {
					speak("Need to confirm with control digits first...", fromVoice)
				} else {
					pluckList?.finishedAt = Date()
					
					setCurrentStep(.START)
					updateActivePage(.LOBBY)
					speak("Say 'start' to start a new pluck order", fromVoice)
				}
			default:
				return
			}
		}
	}
	
	/**
	 Checks if the keyword entered is a control digit
	 
	 - Returns: the control digit if the keyword is a control digit. `nil` is returned otherwise
	 */
	private func isControlDigits(_ keyword: String) -> Int? {
		guard let keywordInt = Int(keyword) else {
			return nil
		}
		
		guard keyword.count == 3 else {
			return nil
		}
		
		return keywordInt
	}
	
	/**
	 Returns a date formatter
	 */
	private func getFormatter() -> DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
		
		return formatter
	}
	
	/** Updates the active page
	 
	 - Parameters:
	 - page: The page to update to
	 */
	private func updateActivePage(_ page: PluckPages) {
		withAnimation {
			DispatchQueue.main.async { [weak self] in
				self?.activePage = page
			}
		}
	}
	
	/**
	 Plays a string to the device audio output
	 
	 - Parameters:
	 - utterance: the string to be played to the speaker
	 - fromVoice: a boolean discribing if commands where given via voice or touch.
	 If they were given through voice, the utterance is played on the speakers.
	 If the commands are given through touch, the utterance is not played on the speakers
	 */
	private func speak(_ utterance: String, _ fromVoice: Bool) {
		if (fromVoice) {
			let speechUtterance = AVSpeechUtterance(string: utterance)
			speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2
			speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
			speechUtterance.volume = 1.0
			speechUtterance.pitchMultiplier = 1.0
			
			speechSynthesizer.speak(speechUtterance)
		}
	}
	
	/**
	 Sets the currect step in a page.
	 */
	private func setCurrentStep(_ currentStep: Steps){
		DispatchQueue.main.async { [weak self] in
			self?.currentStep = currentStep
		}
	}
	
	/**
	 Sets plucklist, fixes published in child
	 */
	func setPluckList(_ pluckList: PluckList){
		DispatchQueue.main.async { [weak self] in
			self?.pluckList = pluckList
		}
	}
	
	/**
	 Sets the cargocarrier
	 */
	func setCargoCarriers(_ cargoCarriers: [CargoCarrier]){
		DispatchQueue.main.async { [weak self] in
			self?.cargoCarriers = cargoCarriers
		}
	}
	
	func move(source: IndexSet, destination: Int) {
		pluckList?.plucks.move(fromOffsets: source, toOffset: destination)
	}
}
