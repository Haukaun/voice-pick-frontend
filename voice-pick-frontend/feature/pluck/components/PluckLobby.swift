//
//  PluckLobby.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 15/02/2023.
//

import SwiftUI

struct PluckLobby: View {
    let next: () -> Void
    let addPlucks: ([Pluck]) -> Void
    
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
        addPlucks([
            .init(id: 1, productName: "6-pack Coca Cola", location: "HB-219", quantity: 2, type: .D_PACK, status: .READY, weight: 18),
            .init(id: 2, productName: "Kiwi Bæreposer", location: "I-227", quantity: 8, type: .D_PACK, status: .READY, weight: 52),
            .init(id: 3, productName: "Brelett Smør", location: "KC-115", quantity: 1, type: .F_PACK, status: .READY, weight: 0.5)
        ])
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
