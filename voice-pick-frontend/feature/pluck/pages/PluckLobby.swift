//
//  PluckLobby.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 15/02/2023.
//

import SwiftUI
import Foundation

struct PluckLobby: View {
	let next: () -> Void
	
	@State var activeEmployees = [
		"Joakim Edvardsen",
		"Petter Molnes",
		"Håkon Sætre",
		"Mati"
	]
	
	@StateObject var requestService = RequestService()
	@State var pluckList: PluckList?
	
	/// Initializes a pluck list
	func startPluck() {
		requestService.get(path: "/plucks", responseType: PluckList.self, completion: { result in
			switch result {
			case .success:
				next()
				
			case .failure(let error):
				print("Error fetching pluck list: \(error.localizedDescription)")
			}
		})
	}
	
	var body: some View {
		VStack {
			Card {
				ActivePickers(activePickers: activeEmployees)
			}
			DefaultButton("Start plukk") {
				next()
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding(10)
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
		PluckLobby(next: {
			print("next")
		})
	}
}
