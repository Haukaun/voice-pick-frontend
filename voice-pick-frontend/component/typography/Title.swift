//  A title component used for main titles
//
//  Title.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 15/02/2023.
//

import SwiftUI

struct Title: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(Font.header1)
            .foregroundColor(.foregroundColor)
    }
    
    init(_ text: String) {
        self.text = text
    }
}

struct Title_Previews: PreviewProvider {
    static var previews: some View {
        Title("A title")
    }
}
