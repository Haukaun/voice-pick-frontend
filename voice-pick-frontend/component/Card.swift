//  A card component used to wrap content to give it
//  a card look
//
//
//  Card.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 15/02/2023.
//

import SwiftUI

struct Card<Content: View>: View {
    var content: Content
    
    var body: some View {
        VStack {
            content
        }
        .padding(20)
        .background(Color.componentColor)
        .cornerRadius(UIView.standardCornerRadius)
        .shadow(
            color: Color.shadowColor,
            radius: UIView.shadowRadius,
            x: UIView.shadowX,
            y: UIView.shadowY
        )
    }
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Card {
                Text("hello there")
                Text("Another text")
            }
        }
        .padding(20)
    }
}
