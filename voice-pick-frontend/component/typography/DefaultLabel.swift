//
//  DefaultLabel.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 17/02/2023.
//

import SwiftUI

struct DefaultLabel: View {
    var text: String
    
    var body: some View {
        Text(text)
    }
    
    init(_ text: String) {
        self.text = text
    }
}

struct DefaultLabel_Previews: PreviewProvider {
    static var previews: some View {
        DefaultLabel("A label")
    }
}
