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
	
	@ObservedObject private var pluckService = PluckPageService()

	
	
	var body: some View {
		VStack {
			if pluckService.activePage != .COMPLETE {
				Header(headerText: "Plukkliste")
			}
			VoiceView(onChange: { newValue in
				pluckService.doAction(keyword: newValue, fromVoice: true)
			}){
				switch pluckService.activePage {
				case .LOBBY:
					PluckLobby(next: {
						pluckService.doAction(keyword: "start", fromVoice: false)
					})
					.transition(.backslide)
				case .INFO:
					PluckInfo(cargoCarriers: pluckService.cargoCarriers, next: {
						pluckService.doAction(keyword: "next", fromVoice: false)
					})
					.transition(.backslide)
					.onAppear{
						requestService.get(path: "/cargo-carriers", responseType: [CargoCarrier].self, completion: {result in
							switch result {
							case .success(let cargoCarriers):
								pluckService.setCargoCarriers(cargoCarriers)
								break
							case .failure(let error):
								print(error)
							}
						})
					}
					.environmentObject(pluckService)
				case .LIST_VIEW:
					PluckListDisplay(pluckService.pluckList?.plucks ?? [], next: {
						pluckService.updateActivePage(.COMPLETE)
					})
					.transition(.backslide)
				case .COMPLETE:
					PluckComplete(next: {
						pluckService.updateActivePage(.DELIVERY)
					})
					.transition(.backslide)
				case .DELIVERY:
					PluckFinish(next: {
						pluckService.updateActivePage(.LOBBY)
						pluckService.setCurrentStep(.START)
					})
					.transition(.backslide)
				}
			}
		}
		.background(Color.backgroundColor)
	}
}

struct PluckPage_Previews: PreviewProvider {
	static var previews: some View {
		PluckPage()
	}
}
