//  A wrapper page responsible for maintaining controller
//  over which pluck page to display
//
//  PluckPage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 16/02/2023.
//

import SwiftUI

struct PluckPage: View {
    
    enum PluckPages {
        case LOBBY
        case INFO
        case LIST_VIEW
        case SINGLE_VIEW
        case COMPLETE
        case DELIVERY
    }
    
    @State var activePage: PluckPages = .LOBBY
    @State var plucks: [Pluck] = []
    
    /// Updates the list with plucks
    ///
    /// - Parameters:
    ///     - plucks: A list with updated values for the plucks
    func updatePlucks(plucks: [Pluck]) {
        self.plucks = plucks
    }
    
    /// Updates the active page
    ///
    /// - Parameters:
    ///     - page: The page to update to
    func updateActivePage(page: PluckPages) {
        self.activePage = page
    }
    
    var body: some View {
        switch activePage {
            case .LOBBY:
                PluckLobby(next: {
                    updateActivePage(page: .INFO)
                }, addPlucks: 
                    updatePlucks
                )
                .transition(.backslide)
            case .INFO:
                PluckInfo(plucks: plucks)
                .transition(.backslide)
            case .LIST_VIEW:
                Text("List view")
                .transition(.slide)
            case .SINGLE_VIEW:
                Text("Single view")
                .transition(.slide)
            case .COMPLETE:
                Text("Complete")
                .transition(.slide)
            case .DELIVERY:
                Text("Delivery")
                .transition(.slide)
        }
    }
}

struct PluckPage_Previews: PreviewProvider {
    static var previews: some View {
        PluckPage()
    }
}
