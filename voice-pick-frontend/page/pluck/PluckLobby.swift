//
//  PluckLobby.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 15/02/2023.
//

import SwiftUI

struct PluckLobby: View {
    let pageTitle = "Aktive plukkere"
    let buttonLabel = "Start plukk"
    
    @State var activeEmployees = [
        "Joakim Edvardsen",
        "Petter Molnes",
        "Håkon Sætre"
    ]
    
    var body: some View {
        VStack {
            Card {
                ActivePickers(activePickers: activeEmployees)
            }
            DefaultButton(buttonText: buttonLabel)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(10)
        .background(Color.backgroundColor)
    }
}

struct PluckLobby_Previews: PreviewProvider {
    static var previews: some View {
        PluckLobby()
    }
}
