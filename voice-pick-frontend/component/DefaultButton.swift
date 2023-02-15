//
//  LoginButton.swift
//  voice-pick-frontend
//
//  Created by tama on 13/02/2023.
//

import SwiftUI

struct DefaultButton: View {
    var buttonText: String
    
    var body: some View {
        Button(action: {
            print("Login tapped!")
        }) {
            HStack {
                Spacer()
                Text(buttonText)
                    .fontWeight(.bold)
                    .font(.button)
                Spacer()
            }
            .padding()
            .foregroundColor(.night)
            .background(Color.traceLightYellow)
						.cornerRadius(UIView.standardCornerRadius)
            
        }
    }
}

struct DefaultButton_Previews: PreviewProvider {
    static var previews: some View {
        DefaultButton(buttonText: "click")
    }
}
