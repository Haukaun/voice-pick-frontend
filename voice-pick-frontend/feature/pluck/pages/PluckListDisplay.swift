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
		NavigationView {
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
				.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
				.listRowSeparator(.hidden)
				.listRowBackground(Color.clear)
			}
			.scrollContentBackground(.hidden)
			.padding(.init(top: 0, leading: 5, bottom: 5, trailing: 5))
			.listStyle(PlainListStyle())
			.background(Color.backgroundColor)
		}

	}
}

struct PluckListDisplay_Previews: PreviewProvider {
	
	static func initPluckService() -> PluckService {
		let pluckService = PluckService()
		
		let location = Location(id: 0, code: "P345", controlDigits: 123)
		
		let product1 = Product(id: 1, name: "Coca-Cola", weight: 0.5, volume: 0.8, quantity: 10, type: .D_PACK, status: .READY, location: location)
		let product2 = Product(id: 2, name: "Pepsi Brus", weight: 1.0, volume: 1.5, quantity: 5, type: .F_PACK, status: .EMPTY, location: location)
		
		let pluck1 = Pluck(id: 1, product: product1, amount: 2, amountPlucked: 0, createdAt: "2023-04-12T12:00:00", confirmedAt: nil, pluckedAt: nil)
		let pluck2 = Pluck(id: 2, product: product2, amount: 3, amountPlucked: 0, createdAt: "2023-04-12T12:30:00", confirmedAt: nil, pluckedAt: nil)
		
		pluckService.setPluckList(.init(
			id: 0,
			route: "234",
			destination: "Kiwi Nedre Strandgate 2",
			user: User(id: "1", firstName: "Ola", lastName: "Nordmann", email: "olanordmann@icloud.com"),
			plucks: [pluck1, pluck2],
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
