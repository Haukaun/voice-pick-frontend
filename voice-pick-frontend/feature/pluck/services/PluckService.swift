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
import OSLog

enum Steps {
	case START
	case SELECT_CARGO
	case SELECT_CONTROL_DIGITS
	case CONFIRM_PLUCK
	case DELIVERY
}

class PluckService: ObservableObject {
	@Published var currentStep: Steps = .START
	@Published var activePage: PluckPages = .LOBBY
	@Published var pluckList: PluckList?
	@Published var cargoCarriers: [CargoCarrier] = []
	@Published var requestService = RequestService()
	
	@Published var showAlert = false;
	@Published var errorMessage = "";
	@Published var isLoading: Bool = false
    
    @Published var isMuted = false
    
    var token: String? = nil
	
	private var ttsService = TTSService.shared
	
	let audioSession: AVAudioSession
	let speechSynthesizer = AVSpeechSynthesizer()
	
	let numberStringMap: [String: Int] = [
		"one": 1,
		"two": 2,
		"three": 3,
		"four": 4,
		"five": 5,
		"six": 6,
		"seven": 7,
		"eight": 8,
		"nine": 9
	]
	
	init() {
		audioSession = AVAudioSession.sharedInstance()
		configureAudioSession()
	}
	
	func configureAudioSession() {
		do {
			if isBluetoothConnected() {
				try audioSession.setCategory(.playAndRecord, mode: .default, options: [.allowBluetoothA2DP, .mixWithOthers])
			} else {
				try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers])
			}
			try audioSession.setActive(true)
		} catch {
			os_log("Error with configuring audio device", type: .error)
		}
	}
	
	func isBluetoothConnected() -> Bool {
		let routes = audioSession.currentRoute
		for output in routes.outputs {
			if output.portType == .bluetoothA2DP || output.portType == .bluetoothLE || output.portType == .bluetoothHFP {
				return true
			}
		}
		return false
	}
	
	/**
	 A function that handles action made either through the UI or through voice
	 
	 - Parameters:
	 - keyword: a keyword describing the action that was made
	 - fromVoice: a boolean describing if the action was made via coide. `true` if yes, `false` otherwise
	 */
	func doAction(keyword: String, fromVoice: Bool, token: String? = nil) {
        print(keyword)
        print(currentStep)
        
        self.token = token
        
        // If voice is muted, only listen for the keyword "listen"
        if (self.isMuted && fromVoice) {
            if keyword == "listen" {
                self.isMuted = false
            }
        } else {
            if keyword == "mute" {
                self.isMuted = true
            } else if keyword == "listen" {
                self.isMuted = false
            } else {
                switch currentStep {
                case .START:
                    handleStartActions(keyword, fromVoice)
                    break
                case .SELECT_CARGO:
                    handleCargoAction(keyword, fromVoice)
                    break
                case .SELECT_CONTROL_DIGITS:
                    handleControlDigits(keyword, fromVoice)
                    break
                case .CONFIRM_PLUCK:
                    handleConfirmPluck(keyword, fromVoice)
                    break
                case .DELIVERY:
                    handleDeliveryAction(keyword, fromVoice)
                    break
                }
            }
        }
	}
	
	/**
	 Handles all actions available from start page
	 
	 - Parameters:
	 - keyword: the keyword of the action to make
	 - fromVoice: a boolean describing if the action was made via voice. `true` if yes, `false` otherwise
	 */
	private func handleStartActions(_ keyword: String, _ fromVoice: Bool) {
		switch keyword {
		case "start":
			if let token = token, !token.isEmpty {
				isLoading = true
				initializePlucklist(fromVoice)
			} else {
				ttsService.speak("Unauthorized. Try to log back in", fromVoice)
			}
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
	}
	
	/*
	 Error handling for plucklist
	 */
	func handleError(errorCode: Int) {
        DispatchQueue.main.async {
            switch errorCode {
            case 204:
                self.showAlert = true
                self.errorMessage = "Ingen plukkliste funnet for øyeblikket. Vennligst vent på nye plukk."
                break
            case 401:
                self.showAlert = true
                self.errorMessage = "Uautorisert. Logg ut og logg inn igjen og prøv på nytt."
            case 422:
                self.showAlert = true
                self.errorMessage = "Noe gikk galt med behandlingen av dataene."
                break
						case 404:
							self.showAlert = true
							self.errorMessage = "Ikke nok lokasjoner eller produkt til å generere plukk liste."
            default:
                self.showAlert = true;
                self.errorMessage = "Noe gikk galt, vennligst avslutt applikasjonen og prøv igjen, eller rapporter en feil."
                break
            }
        }
	}
	/**
	 Initializes a new plucklist
	 */
	private func initializePlucklist(_ fromVoice: Bool) {
        requestService.get(path: "/pluck-lists", token: self.token, responseType: PluckList.self, completion: { [self] result in
			DispatchQueue.main.async {
				self.isLoading = false
			}
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
				setCurrentStep(.SELECT_CONTROL_DIGITS)
				updateActivePage(.LIST_VIEW)
				if let index = pluckList?.plucks.firstIndex(where: { $0.pluckedAt == nil }) {
					ttsService.speak("\(pluckList?.plucks[index].product.location?.code ?? "")", fromVoice)
				}
			}
		default:
			let found = cargoCarriers.first(where: {$0.phoneticIdentifier == keyword})
			if (found != nil) {
				// TODO: Send request to api to update cargo carrier for plucklist
				pluckList?.cargoCarrier = found
				ttsService.speak("\(found!.name) selected", fromVoice)
			}
		}
	}
	
	private func handleControlDigits(_ keyword: String, _ fromVoice: Bool) {
		guard let currentPluckIndex = pluckList?.plucks.firstIndex(where: { $0.pluckedAt == nil }) else {
			return
		}
		
		// Check if keyword entered is a control digit
		if let keywordInt = isControlDigits(keyword) {
			// Check if the control digits entered are correct
			if (keywordInt == pluckList?.plucks[currentPluckIndex].product.location?.controlDigits) {
				withAnimation {
					self.pluckList?.plucks[currentPluckIndex].confirmedAt = Date()
				}
				let amountInt = pluckList?.plucks[currentPluckIndex].amount
				if let amount = amountInt {
					ttsService.speak(String(amount), fromVoice)
				}
				self.setCurrentStep(.CONFIRM_PLUCK)
			} else {
				ttsService.speak("Wrong control digits. Try again", fromVoice)
			}
		} else {
			switch keyword {
			case "help":
				ttsService.speak("Select correct control digits", fromVoice)
			case "repeat":
				ttsService.speak(pluckList?.plucks[currentPluckIndex].product.location?.code ?? "", fromVoice)
			case "complete":
				ttsService.speak("Select control digits and amount before continuing", fromVoice)
			case "cancel":
				ttsService.stopSpeak()
			default:
				return
			}
		}
	}
	
	private func handleSelectAmount(_ keyword: String, _ fromVoice: Bool) {
		guard let currentPluckIndex = pluckList?.plucks.firstIndex(where: { $0.pluckedAt == nil }) else {
			return
		}
		
		switch keyword {
		case "help":
			ttsService.speak("Enter the correct amount", fromVoice)
		case "repeat":
			let amountInt = pluckList?.plucks[currentPluckIndex].amount
			if let amount = amountInt {
				ttsService.speak(String(amount), fromVoice)
			}
		case "complete":
			ttsService.speak("Enter correct amount before completing", fromVoice)
		case "cancel":
			ttsService.stopSpeak()
		default:
			var keywordInt: Int?
			if (numberStringMap.contains(where: { $0.key == keyword })) {
				keywordInt = numberStringMap[keyword]
			} else {
				keywordInt = Int(keyword)
			}
			
			if let keywordInt = keywordInt {
				pluckList?.plucks[currentPluckIndex].amountPlucked = keywordInt
                let rightAmountEntered = pluckList?.plucks[currentPluckIndex].amountPlucked == pluckList?.plucks[currentPluckIndex].amount
				if  rightAmountEntered && fromVoice {
                    confirmPluck(currentPluckIndex, fromVoice)
                } else if rightAmountEntered {
                    self.setCurrentStep(.CONFIRM_PLUCK)
                }
			}
		}
	}
	
    private func handleConfirmPluck(_ keyword: String, _ fromVoice: Bool) {
		guard let currentPluckIndex = pluckList?.plucks.firstIndex(where: { $0.pluckedAt == nil }) else {
			return
		}
		
		switch keyword {
		case "help":
			ttsService.speak("Enter the correct amount then say 'complete' to complete the pluck", fromVoice)
		case "repeat":
			let amountInt = pluckList?.plucks[currentPluckIndex].amount
			if let amount = amountInt {
				ttsService.speak(String(amount), fromVoice)
			}
		case "cancel":
			ttsService.stopSpeak()
		case "complete":
			if pluckList?.plucks[currentPluckIndex].amountPlucked != pluckList?.plucks[currentPluckIndex].amount {
				ttsService.speak("Enter correct amount before completing", fromVoice)
			} else {
				confirmPluck(currentPluckIndex, fromVoice)
			}
		default:
			var keywordInt: Int?
			if (numberStringMap.contains(where: { $0.key == keyword })) {
				keywordInt = numberStringMap[keyword]
			} else {
				keywordInt = Int(keyword)
			}
			
			if let keywordInt = keywordInt {
				pluckList?.plucks[currentPluckIndex].amountPlucked = keywordInt
                let rightAmountEntered = pluckList?.plucks[currentPluckIndex].amountPlucked == pluckList?.plucks[currentPluckIndex].amount
                if  rightAmountEntered && fromVoice {
                    confirmPluck(currentPluckIndex, fromVoice)
                } else if rightAmountEntered {
                    self.setCurrentStep(.CONFIRM_PLUCK)
                }
			}
		}
	}
    
    private func confirmPluck(_ pluckIndex: Int, _ fromVoice: Bool) {
        pluckList?.plucks[pluckIndex].pluckedAt = Date()
        
        // Send request to api to update pluck values
        let pluck = pluckList?.plucks[pluckIndex]
        guard let pluck = pluck else {
            return
        }
        let pluckId = pluck.id
        let dateFormatter = ISO8601DateFormatter()
        
        let confirmedAt = pluck.confirmedAt != nil ? dateFormatter.string(from: pluck.confirmedAt!) : nil
        let pluckedAt = pluck.pluckedAt != nil ? dateFormatter.string(from: pluck.pluckedAt!) : nil
        
        let requestBody = UpdatePluckRequest(
            amountPlucked: pluck.amountPlucked,
            confirmedAt: confirmedAt,
            pluckedAt: pluckedAt
        )
        requestService.patch(
            path: "/plucks/\(pluckId)",
            token: self.token,
            body: requestBody,
            responseType: String.self,
            completion: { result in
                switch result {
                case .success(_):
                    print("Pluck successfully updated")
                    break
                case .failure(let error as RequestError):
                    self.handleError(errorCode: error.errorCode)
                default:
                    break
                }
            }
        )
        
        // If all plucks are completed
        if (pluckList?.plucks.filter{ $0.pluckedAt == nil }.count == 0) {
            updateActivePage(.COMPLETE)
            ttsService.speak("All plucks completed", fromVoice)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.async { [self] in
                    self.updateActivePage(.DELIVERY)
                    self.setCurrentStep(.DELIVERY)
                }
            }
            ttsService.speak(pluckList?.location.code ?? "", fromVoice)
        } else {
            // Find next pluck and utter the location
            let nextPluck = pluckList?.plucks.first(where: { $0.pluckedAt == nil })
					ttsService.speak(nextPluck?.product.location?.code ?? "", fromVoice)
            
            handleRearangePluck()
        }
    }
	
	private func handleDeliveryAction(_ keyword: String, _ fromVoice: Bool) {
		if let keywordInt = isControlDigits(keyword) {
			if (keywordInt == pluckList?.location.controlDigits) {
				withAnimation {
					pluckList?.confirmedAt = Date()
				}
                ttsService.speak("Pluck completed", fromVoice)
                if fromVoice {
                    registerCompletPluckList()
                    setCurrentStep(.START)
                    updateActivePage(.LOBBY)
                    ttsService.speak("Say 'start' to start a new pluck order", fromVoice)
                }
			} else {
				ttsService.speak("Wrong control digits. Try again", fromVoice)
			}
		} else {
			switch keyword {
			case "repeat":
				ttsService.speak(pluckList?.location.code ?? "", fromVoice)
			case "help":
				ttsService.speak("Confirm control digit, then say 'complete' to finish the pluck", fromVoice)
			case "cancel":
				ttsService.stopSpeak()
			case "complete":
				if (pluckList?.confirmedAt == nil) {
					ttsService.speak("Need to confirm with control digits first...", fromVoice)
				} else {
					pluckList?.finishedAt = Date()
                    registerCompletPluckList()
					
					setCurrentStep(.START)
					updateActivePage(.LOBBY)
					ttsService.speak("Say 'start' to start a new pluck order", fromVoice)
				}
			default:
				return
			}
		}
	}
    
    func registerCompletPluckList() {
        guard let pluckList = self.pluckList else {
            return
        }
        
        let id = pluckList.id
        let dateFormatter = ISO8601DateFormatter()

        let confirmedAt = pluckList.confirmedAt != nil ? dateFormatter.string(from: pluckList.confirmedAt!) : nil
        let finishedAt = pluckList.finishedAt != nil ? dateFormatter.string(from: pluckList.finishedAt!) : nil
        let body = UpdatePluckListRequest(confirmedAt: confirmedAt, finishedAt: finishedAt)
            
        requestService.patch(
            path: "/pluck-lists/\(id)",
            token: self.token,
            body: body,
            responseType: String.self,
            completion: { result in
                switch result {
                case .success(_):
                    print("Plucklist successfully updated")
                    break
                case .failure(let error as RequestError):
                    self.handleError(errorCode: error.errorCode)
                default:
                    break
                }
            }
        )
    }
	
	/**
	 Updates to correct step when items in the pluck list are rearrenged
	 */
    func handleRearangePluck() {
		let nextPluck = pluckList?.plucks.first(where: { $0.pluckedAt == nil })
            
		// Check state of next pluck
		if nextPluck?.confirmedAt == nil {
			self.setCurrentStep(.SELECT_CONTROL_DIGITS)
		} else {
			self.setCurrentStep(.CONFIRM_PLUCK)
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
			DispatchQueue.main.async { [weak self] in
				withAnimation{
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
		self.handleRearangePluck()
	}
}
