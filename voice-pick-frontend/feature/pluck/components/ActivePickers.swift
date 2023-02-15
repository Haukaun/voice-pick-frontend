//
//  ActivePickers.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 15/02/2023.
//

import SwiftUI

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

struct ActivePickers_Previews: PreviewProvider {
    static var previews: some View {
        Card {
            ActivePickers(activePickers: ["Test 1", "Test 2"])
        }
    }
}
