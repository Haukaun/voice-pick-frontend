//
//  PluckListDisplay.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/02/2023.
//

import SwiftUI

struct PluckListDisplay: View {
	@EnvironmentObject private var pluckService: PluckService
	
	/// Moves an item in the list of products
	///
	/// - Parameters:
	///     - source: The index of the item to move
	///     - destination: The index of the place to move the item to
	///
	func onMove(source: IndexSet, destination: Int) {
		pluckService.move(source: source, destination: destination)
	}
	
	var body: some View {
		List {
			ForEach(pluckService.pluckList?.plucks ?? [], id: \.id) { pluck in
				if (pluck.pluckedAt == nil) {
					PluckCard(pluck: pluck,
										onSelectedControlDigit: { number in
						pluckService.doAction(keyword: String(number), fromVoice: false)
					},

										onComplete: { id in
						pluckService.doAction(keyword: "complete", fromVoice: false)
					},
										showControlDigits: pluck.confirmedAt == nil,
										disableControlDigits: pluck.id != pluckService.pluckList?.plucks.filter{ $0.pluckedAt == nil }.first?.id
					)
				}
			}
			.onMove(perform: onMove)
			.frame(maxWidth: .infinity)
			.listRowInsets(EdgeInsets())
			.listRowSeparator(.hidden)
		}
		.scrollContentBackground(.hidden)
		.padding(.init(top: 0, leading: 5, bottom: 5, trailing: 5))
		.listStyle(PlainListStyle())
		.background(Color.backgroundColor)
	}
}

struct PluckListDisplay_Previews: PreviewProvider {
	
	static func initPluckService() -> PluckService {
		let pluckService = PluckService()
		
		pluckService.setPluckList(.init(
			id: 0,
			route: "234",
			destination: "Kiwi Nedre Strandgate 2",
			plucks: [],
			location: .init(
				id: 0,
				code: "P345",
				controlDigits: 123)))
		
		return pluckService
	}
	
	static var previews: some View {
		PluckListDisplay()
			.environmentObject(initPluckService())
	}
}
