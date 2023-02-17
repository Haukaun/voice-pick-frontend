//
//  LoginButton.swift
//  voice-pick-frontend
//
//  Created by tama on 13/02/2023.
//

import SwiftUI

struct DefaultButton: View {
    var buttonText: String
    var onPress: () -> Void
    
    var body: some View {
        Button(action: onPress) {
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
            .cornerRadius(5)
						.shadow(color: Color.black.opacity(0.2) ,radius: 5, y: 5)
        }
    }
    
    init (_ title: String, onPress: @escaping () -> Void) {
        self.buttonText = title
        self.onPress = onPress
    }
}

struct DefaultButton_Previews: PreviewProvider {
    static var previews: some View {
        DefaultButton("click") {
            print("Hello")
        }
    }
}
