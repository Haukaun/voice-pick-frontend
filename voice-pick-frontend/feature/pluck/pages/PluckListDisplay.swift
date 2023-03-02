//
//  PluckListDisplay.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/02/2023.
//

import SwiftUI

struct PluckListDisplay: View {
    @State private var plucks: [PluckCard]
    let next: () -> Void
    
    /// Completes a pluck
    ///
    /// - Parameters:
    ///     - id: The id of the pluck to delete
    func complete(id: Int) {
        // Make call to API
        plucks.removeAll(where: { $0.id == id })
        
        if (plucks.count == 0) {
            next();
        }
    }
    
    /// Moves an item in the list of products
    ///
    /// - Parameters:
    ///     - source: The index of the item to move
    ///     - destination: The index of the place to move the item to
    ///
    func onMove(source: IndexSet, destination: Int) {
        plucks.move(fromOffsets: source, toOffset: destination)
    }
	
	var body: some View {
		NavigationView {
			List {
				ForEach(plucks, id: \.self) { pluck in
                    pluck
                        .swipeActions(edge: .trailing, content:{
                            Button(role: .destructive) {
                                complete(id: pluck.id)
                            } label: {
                                Label("Svipe venstre for å fullføre" , systemImage: "checkmark.circle.fill")
                            }
                            .tint(.success)
                        })
				}
                .onMove(perform: onMove)
				.listRowInsets(EdgeInsets())
				.padding(5)
				.listRowSeparator(.hidden)
			}.listStyle(PlainListStyle())
				.frame(maxWidth: .infinity)
				.navigationBarItems(leading: EditButton())
		}
	}
    
    init (_ plucks: [Pluck], next: @escaping () -> Void) {
        self.plucks = plucks.map { (pluck) -> PluckCard in
            return PluckCard(id: pluck.id,name: pluck.product.name, location: pluck.product.location, amount: pluck.amount, weight: pluck.product.weight, type: pluck.product.type, status: pluck.product.status)
        }
        self.next = next
    }
}

struct PluckListDisplay_Previews: PreviewProvider {
	static var previews: some View {
		PluckListDisplay([
            .init(
                id: 0,
                product:
                        .init(
                            id: 0,
                            name: "6-pack Coca Cola",
                            location: "HB-219",
                            weight: 9,
                            volume: 9,
                            quantity: 20,
                            type: .D_PACK,
                            status: .READY),
                amount: 2,
                isPlucked: false),
            .init(
                id: 1,
                product:
                        .init(
                            id: 1,
                            name: "Kiwi Bæreposer",
                            location: "I-227",
                            weight: 15,
                            volume: 5,
                            quantity: 50,
                            type: .D_PACK,
                            status: .READY),
                amount: 8,
                isPlucked: false),
            .init(
                id: 2,
                product: .init(
                    id: 2,
                    name: "Idun Hambuger Dressing",
                    location: "O-201",
                    weight: 1,
                    volume: 1,
                    quantity: 145,
                    type: .F_PACK,
                    status: .READY),
                amount: 12,
                isPlucked: false)
        ], next: { print("next") })
	}
}
