//
//  PluckPageViewModel.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 17/03/2023.
//

import Foundation
import SwiftUI
import Combine

class PluckPageService: ObservableObject {
	@Published var currentStep: Steps = .START
	@Published var activePage: PluckPages = .LOBBY
	@Published var pluckList: PluckList?
	@Published var cargoCarriers: [CargoCarrier] = []
	@Published var requestService = RequestService()
	
	/**
	 A function that handles action made either through the UI or through voice
	 
	 - Parameters:
	 - keyword: a keyword describing the action that was made
	 - fromVoice: a boolean describing if the action was made via coide. `true` if yes, `false` otherwise
	 */
	func doAction(keyword: String, fromVoice: Bool, token: String? = nil) {
		print(keyword)
		
		switch currentStep {
		case .START:
			handleStartActions(keyword, fromVoice, token)
			break
		case .SELECT_CARGO:
			handleCargoAction(keyword, fromVoice)
			break
		case .INFO:
			handleInfoAction(keyword, fromVoice)
			break
		}
	}
	
	/**
	 Handles all actions available from start page
	 
	 - Parameters:
	 - keyword: the keyword of the action to make
	 - fromVoice: a boolean describing if the action was made via voice. `true` if yes, `false` otherwise
	 */
	func handleStartActions(_ keyword: String, _ fromVoice: Bool, _ token: String? = nil) {
		switch keyword {
		case "start":
			initializePlucklist(token)
			break
		default:
			if (fromVoice) {
				print("Si 'Start' for å gå videre")
			}
		}
	}
	
	/**
	 Handles all actions available from select cargo step
	 
	 - Parameters:
	 - keyword: the keyword of the action to make
	 - fromVoice: a boolean describing if the action was made via voice. `true` if yes, `false` otherwise
	 */
	func handleCargoAction(_ keyword: String, _ fromVoice: Bool) {
		let found = cargoCarriers.first(where: {$0.phoneticIdentifier == keyword})
		
		if (found != nil) {
			pluckList?.cargoCarrier = found
			setCurrentStep(.INFO)
		} else {
			print("Error")
		}
	}
	
	/**
	 Handles all actions available from info step
	 
	 - Parameters:
	 - keyword: the keyword of the action to make
	 - fromVoice: a boolean describing if the action was made via voice. `true` if yes, `false` otherwise
	 */
	func handleInfoAction(_ keyword: String, _ fromVoice: Bool) {
		switch keyword {
		case "next":
			print("here")
			updateActivePage(.LIST_VIEW)
			break
		default:
			if (fromVoice) {
				print("Si 'Neste' for å gå videre")
			}
		}
	}
	

	
	/**
	 Initializes a new plucklist
	 */
	func initializePlucklist(_ token: String? = nil) {
		requestService.get(path: "/plucks", header: token, responseType: PluckList.self, completion: { [self] result in
			switch result {
			case .success(let pluckList):
				setPluckList(pluckList)
				setCurrentStep(.SELECT_CARGO)
				updateActivePage(.INFO)
			case .failure(let error):
				print(error)
			}
		})
	}
	
	/** Updates the active page
	 
	 - Parameters:
	 - page: The page to update to
	 */
	func updateActivePage(_ page: PluckPages) {
		withAnimation {
			DispatchQueue.main.async { [weak self] in
				self?.activePage = page
			}
		}
	}
	
	/**
	 Sets the currect step in a page.
	 */
	func setCurrentStep(_ currentStep: Steps){
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
}
