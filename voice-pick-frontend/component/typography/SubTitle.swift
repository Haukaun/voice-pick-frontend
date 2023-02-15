//  A subtitle component used for subtitles
//
//  SubTitle.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 15/02/2023.
//

import SwiftUI

struct SubTitle: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(Font.header2)
            .foregroundColor(.foregroundColor)
    }
    
    init(_ text: String) {
        self.text = text
    }
}

struct SubTitle_Previews: PreviewProvider {
    static var previews: some View {
        SubTitle("A subtitle")
    }
}
