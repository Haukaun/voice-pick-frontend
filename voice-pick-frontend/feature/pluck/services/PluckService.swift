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
	
	@State var showAlert = false;
	@State var errorMessage = "";
	
	private var ttsService = TTSService()
	
	let audioSession: AVAudioSession
	let speechSynthesizer = AVSpeechSynthesizer()
	
	init() {
		audioSession = AVAudioSession.sharedInstance()
		do {
			// TODO: Check if bluetooth. If yes set category to this:
			try audioSession.setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth, .allowBluetoothA2DP])
			// if not, set category to this:
			//try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
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
		if let token = token {
			switch keyword {
			case "start":
				initializePlucklist(fromVoice, token)
				break
			case "repeat":
				ttsService.speak("Say 'start' to start a new pluck order", fromVoice)
			case "help":
				ttsService.speak("You only have one option: 'start' to start a new pluck order", fromVoice)
            case "cancel":
                ttsService.stopSpeak()
			default:
				return
			}
		} else {
			ttsService.speak("Unauthorized. Try to log back in", fromVoice)
		}
	}
	
	/**
	 Error handling for plucklist
	 */
	func handleError(errorCode: Int) {
			switch errorCode {
			case 204:
				showAlert = true
				errorMessage = "Ingen plukkliste ble funnet for øyeblikket. Vennligst vent på nye plukk."
				break
			case 422:
				showAlert = true
				errorMessage = "Noe gikk galt med behandlingen av dataene."
				break
			default:
				showAlert = true;
				errorMessage = "Noe gikk galt. Vennligst lukk applikasjonen og prøv på nytt, eller rapporter feilen."
				break
			}
		}

	/**
	 Initializes a new plucklist
	 */
	private func initializePlucklist(_ fromVoice: Bool, _ token: String) {
		requestService.get(path: "/plucks", token: token, responseType: PluckList.self, completion: { [self] result in
			switch result {
			case .success(let pluckList):
				setPluckList(pluckList)
				setCurrentStep(.SELECT_CARGO)
				updateActivePage(.INFO)
				ttsService.speak("Select cargo carrier before continuing", fromVoice)
			case .failure(let error as RequestError):
				handleError(errorCode: error.errorCode)
			default:
				break
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
				ttsService.speak("Say \(cargoCarrier.phoneticIdentifier) for \(cargoCarrier.name)", fromVoice )
			}
			ttsService.speak("Say 'next' after selecting cargo carrier to continue", fromVoice)
			break
		case "repeat":
			ttsService.speak("Select a cargo carrier to continue.", fromVoice)
        case "cancel":
            ttsService.stopSpeak()
		case "next":
			if (pluckList?.cargoCarrier == nil) {
				ttsService.speak("Need to select a cargo carrier", fromVoice)
			} else {
				setCurrentStep(.PLUCK)
				updateActivePage(.LIST_VIEW)
				if let index = pluckList?.plucks.firstIndex(where: { $0.pluckedAt == nil }) {
					ttsService.speak("\(pluckList?.plucks[index].product.location.code ?? "")", fromVoice)
				}
			}
		default:
			let found = cargoCarriers.first(where: {$0.phoneticIdentifier == keyword})
			if (found != nil) {
				// TODO: Send request to api to update cargo carrier for plucklist
				pluckList?.cargoCarrier = found
				ttsService.speak("\(found!.name) selected", fromVoice)
			} else {
				if (pluckList?.cargoCarrier != nil) {
					ttsService.speak("Say 'next' to continue", fromVoice)
				} else {
					ttsService.speak("Need to select a cargo carrier.", fromVoice)
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
				withAnimation {
					pluckList?.plucks[index].confirmedAt = Date()
				}
			} else {
				// Wrong control digits
				ttsService.speak("Wrong control digits. Try again", fromVoice)
			}
		} else {
			// No control digits entered
			switch keyword {
			case "help":
				ttsService.speak("Confirm control digit, then say 'complete' to complete the pluck", fromVoice)
            case "cancel":
                ttsService.stopSpeak()
			case "repeat":
				let index = pluckList?.plucks.firstIndex(where: { $0.confirmedAt == nil })
				
				guard let index = index else {
					return
				}
				
				// Repeat location
				ttsService.speak("\(pluckList?.plucks[index].product.location.code ?? "")", fromVoice)
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
						ttsService.speak("All plucks completed", fromVoice)
						DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
							DispatchQueue.main.async { [self] in
								self.updateActivePage(.DELIVERY)
								self.setCurrentStep(.DELIVERY)
							}
						}
					}
				} else {
					ttsService.speak("Need to confirm pluck first", fromVoice)
				}
			case "back":
				setCurrentStep(.SELECT_CARGO)
				updateActivePage(.INFO)
				ttsService.speak("Select cargo", fromVoice)
			default:
				return
			}
		}
	}
	
	private func handleDeliveryAction(_ keyword: String, _ fromVoice: Bool) {
		if let keywordInt = isControlDigits(keyword) {
			if (keywordInt == pluckList?.location.controlDigits) {
				withAnimation {
					pluckList?.confirmedAt = Date()
				}
				ttsService.speak("Say 'complete' to finish pluck", fromVoice)
			} else {
				ttsService.speak("Wrong control digits. Try again", fromVoice)
			}
		} else {
			switch keyword {
			case "repeat":
				ttsService.speak("Confirm control digit, then say 'complete' to finish the pluck", fromVoice)
			case "help":
				ttsService.speak("Confirm control digit, then say 'complete' to finish the pluck", fromVoice)
            case "cancel":
                ttsService.stopSpeak()
			case "complete":
				if (pluckList?.confirmedAt == nil) {
					ttsService.speak("Need to confirm with control digits first...", fromVoice)
				} else {
					pluckList?.finishedAt = Date()
					
					setCurrentStep(.START)
					updateActivePage(.LOBBY)
					ttsService.speak("Say 'start' to start a new pluck order", fromVoice)
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
