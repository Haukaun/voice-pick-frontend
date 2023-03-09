//  A wrapper page responsible for maintaining controller
//  over which pluck page to display
//
//  PluckPage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 16/02/2023.
//

import SwiftUI

enum Steps {
	case START
	case SELECT_CARGO
	case INFO
}

struct PluckPage: View {
	
	let requestService = RequestService()
	
	@State var currentStep: Steps = .START
	@State var activePage: PluckPages = .LOBBY
	@State var pluckList: PluckList?
	
	/**
	 A function that handles action made either through the UI or through voice
	 
	 - Parameters:
			- keyword: a keyword describing the action that was made
			- fromVoice: a boolean describing if the action was made via coide. `true` if yes, `false` otherwise
	 */
	func doAction(keyword: String, fromVoice: Bool) {
		print(keyword)
		
		switch currentStep {
		case .START:
			handleStartActions(keyword, fromVoice)
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
	func handleStartActions(_ keyword: String, _ fromVoice: Bool) {
		switch keyword {
		case "start":
			initializePlucklist()
			break
		default:
			if (fromVoice) {
				speak("Si 'Start' for å gå videre")
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
		switch keyword {
		case "Halvpall":
			// TODO: Select halvpall
			// TODO: Update current step
			break
		case "Helpall":
			// TODO: Select helpall
			// TODO: Update current step
			break
		default:
			if (fromVoice) {
				speak("Velg lastebærer for å fortsette")
			}
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
		case "Neste":
			// TODO: Go to next step
			break
		default:
			if (fromVoice) {
				speak("Si 'Neste' for å gå videre")
			}
		}
	}
	
	/**
	 Initializes a new plucklist
	 */
	func initializePlucklist() {
		requestService.get(path: "/plucks", responseType: PluckList.self, completion: { result in
			switch result {
			case .success(let pluckList):
				self.pluckList = pluckList
				self.currentStep = .SELECT_CARGO
				updateActivePage(.INFO)
			case .failure(let error):
				print(error)
			}
		})
	}
	
	/// Updates the active page
	///
	/// - Parameters:
	///     - page: The page to update to
	func updateActivePage(_ page: PluckPages) {
		withAnimation {
			self.activePage = page
		}
	}
	
	/**
	 Takes the input and plays through the device
	 
	 - Parameters:
	 - text: the text to be spoken
	 */
	func speak(_ text: String) {
		// TODO: Implement speach
		print(text)
	}
	
	var body: some View {
		VoiceView(onChange: { newValue in
			doAction(keyword: newValue, fromVoice: true)
		}){
			switch activePage {
			case .LOBBY:
				PluckLobby(next: {
					doAction(keyword: "start", fromVoice: false)
				}
				)
				.transition(.backslide)
			case .INFO:
				PluckInfo(pluckList: pluckList ?? .init(id: 0, route: "N/A", destination: "N/A", plucks: []), next: {
					doAction(keyword: "Neste", fromVoice: false)
				})
				.transition(.backslide)
			case .LIST_VIEW:
				PluckListDisplay(pluckList?.plucks ?? [], next: {
					updateActivePage(.COMPLETE)
				})
				.transition(.backslide)
			case .SINGLE_VIEW:
				Text("Single view")
					.transition(.backslide)
			case .COMPLETE:
				PluckComplete(next: {
					updateActivePage(.DELIVERY)
				})
				.transition(.backslide)
			case .DELIVERY:
				PluckFinish(next: {
					updateActivePage(.LOBBY)
				})
				.transition(.backslide)
			}
		}
	}
}

struct PluckPage_Previews: PreviewProvider {
	static var previews: some View {
		PluckPage()
	}
}
