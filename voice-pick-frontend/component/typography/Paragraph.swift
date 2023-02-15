//  A title component used for main titles
//
//  Title.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 15/02/2023.
//

import SwiftUI

struct Paragraph: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.customBody)
            .foregroundColor(.foregroundColor)
    }
    
    init(_ text: String) {
        self.text = text
    }
}

struct Paragraph_Preview: PreviewProvider {
    static var previews: some View {
        Paragraph("A paragraph")
    }
}
