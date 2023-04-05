//
//  PluckLobby.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 15/02/2023.
//

import SwiftUI
import Foundation

struct PluckLobby: View {
	@State var activeEmployees = [
		"Joakim Edvardsen",
		"Petter Molnes",
		"Håkon Sætre",
		"Mati"
	]
	
	@EnvironmentObject private var pluckService: PluckService
	
	var token: String?
	
	var body: some View {
		VStack {
			Card {
				ActivePickers(activePickers: activeEmployees)
			}
			DefaultButton("Start plukk") {
				pluckService.doAction(keyword: "start", fromVoice: false, token: token)
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding(5)
		.background(Color.backgroundColor)
	}
}

struct ActivePickers: View {
	var activePickers: [String]
	
	var body: some View {
		VStack(spacing: 16) {
			// Title
			HStack {
				Title("Aktive plukkere")
				Spacer()
			}
			// Active employees
			ForEach(activePickers, id: \.self) { item in
				HStack {
					Paragraph(item)
					Spacer()
				}
			}
			Spacer()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

struct PluckLobby_Previews: PreviewProvider {
	static var previews: some View {
		PluckLobby(token: "foo")
	}
}
