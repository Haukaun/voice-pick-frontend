//
//  PluckListDisplay.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/02/2023.
//

import SwiftUI

struct PluckListDisplay: View {
    @State private var plucks: [Pluck]
    let next: () -> Void
    
    /// Completes a pluck
    ///
    /// - Parameters:
    ///     - id: The id of the pluck to delete
    func complete(_ id: Int) {
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
        Header(headerText: "Plucklist")
        List{
            ForEach($plucks, id: \.id) { $pluck in
                PluckCard(
                    id: pluck.id,
                    name: pluck.product.name,
                    location: pluck.product.location,
                    amount: pluck.amount,
                    weight: pluck.product.weight,
                    type: pluck.product.type,
                    status: pluck.product.status,
                    onComplete: { id in
                        complete(id)
                    },
                    showControlDigits: pluck.id == plucks.first?.id ? true : false
                )
            }
            .onMove(perform: onMove)
            .listRowInsets(EdgeInsets())
            .padding(5)
            .listRowSeparator(.hidden)
            .frame(maxWidth: .infinity)
        }
        .listStyle(PlainListStyle())
    }
    
    init (_ plucks: [Pluck], next: @escaping () -> Void) {
        print(plucks)
        self.plucks = plucks
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
                            location: .init(id: 0, location: "HB-209", controlDigit: 123),
                            weight: 100.0,
                            volume: 9,
                            quantity: 20,
                            type: .D_PACK,
                            status: .READY),
                amount: 2,
                createdAt: "02-03-2023",
                pluckedAt: nil,
                show: true),
            .init(
                id: 1,
                product:
                        .init(
                            id: 1,
                            name: "Kiwi Bæreposer",
                            location: .init(id: 1, location: "I-207", controlDigit: 222),
                            weight: 100.0,
                            volume: 5,
                            quantity: 50,
                            type: .D_PACK,
                            status: .READY),
                amount: 8,
                createdAt: "02-03-2023",
                pluckedAt: nil,
                show: true),
            .init(
                id: 2,
                product:
                        .init(
                            id: 2,
                            name: "Idun Hambuger Dressing",
                            location: .init(id: 2, location: "O-456", controlDigit: 333),
                            weight: 50.0,
                            volume: 1,
                            quantity: 145,
                            type: .F_PACK,
                            status: .READY),
                amount: 12,
                createdAt: "02-03-2023",
                pluckedAt: nil,
                show: true)
        ], next: { print("next") })
    }
}
