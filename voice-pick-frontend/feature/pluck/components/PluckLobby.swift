//
//  PluckLobby.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 15/02/2023.
//

import SwiftUI

struct PluckLobby: View {
    let next: () -> Void
    let initPluckList: (PluckList) -> Void
    
    let pageTitle = "Aktive plukkere"
    let buttonLabel = "Start plukk"
    
    @State var activeEmployees = [
        "Joakim Edvardsen",
        "Petter Molnes",
        "Håkon Sætre"
    ]
    
    /// Initializes a pluck list
    func startPluck() {
        // TODO: Fetch pluck from back-end and call addPlucks with list from back-end
        let products: [Product] = [
            .init(id: 1, name: "6-pack Coca Cola", location: "HB-219", weight: 9, volume: 9, quantity: 50, type: .D_PACK, status: .READY),
            .init(id: 2, name: "Kiwi Bæreposer", location: "I-227", weight: 15, volume: 5, quantity: 100, type: .D_PACK, status: .READY),
            .init(id: 3, name: "Brelett smør", location: "KC-115", weight: 5, volume: 1, quantity: 75, type: .D_PACK, status: .READY),
            .init(id: 4, name: "Idun Hamburger Dressing", location: "O-201", weight: 0.75, volume: 0.75, quantity: 245, type: .F_PACK, status: .READY)
        ]
        
        let plucks: [Pluck] = [
            .init(id: 0, product: products[0], amount: 2, isPlucked: false),
            .init(id: 1, product: products[1], amount: 8, isPlucked: false),
            .init(id: 2, product: products[2], amount: 1, isPlucked: false),
            .init(id: 3, product: products[3], amount: 1, isPlucked: false)
        ]
        
        let pluckList: PluckList = .init(id: 0, route: "1351", destination: "Jokier Åheim", plucks: plucks)
        
        initPluckList(pluckList)
        
        next()
    }
    
    var body: some View {
        VStack {
            Card {
                ActivePickers(activePickers: activeEmployees)
            }
            DefaultButton(buttonLabel) {
                 startPluck()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(10)
        .background(Color.backgroundColor)
    }
}

struct ActivePickers: View {
    let componentTitle = "Aktive plukkere"
    
    var activePickers: [String]
    
    var body: some View {
        VStack(spacing: 16) {
            // Title
            HStack {
                Title(componentTitle)
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
