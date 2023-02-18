//
//  LoginButton.swift
//  voice-pick-frontend
//
//  Created by tama on 13/02/2023.
//

import SwiftUI

struct DefaultButton: View {
	var buttonText: String
	var disabled: Bool = false;
	var onPress: () -> Void
	
	var body: some View {
		Button(action: onPress) {
			Spacer()
			Text(buttonText)
			Spacer()
		}
		.frame(maxWidth: .infinity)
		.padding()
		.contentShape(Rectangle())
		.font(.button)
		.foregroundColor(.night)
		.background(Color.traceLightYellow)
		.cornerRadius(5)
		.shadow(color: Color.black.opacity(0.2), radius: 5, y: 5)
		.disabled(disabled)
		.opacity(disabled ? 0.5 : 1)
	}

	init (_ title: String, disabled: Bool = false, onPress: @escaping () -> Void) {
        self.buttonText = title
				self.disabled = disabled
        self.onPress = onPress
    }
}

struct DefaultButton_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			DefaultButton("click", disabled: false, onPress: {})
			DefaultButton("click", disabled: true, onPress: {})
		}
		.padding()
	}
}
