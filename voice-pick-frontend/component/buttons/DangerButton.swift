//
//  DangerButton.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 16/03/2023.
//

import SwiftUI

struct DangerButton: View {
	var label: String
	var disabled: Bool = false;
	var onPress: () -> Void
	
	var body: some View {
		Button(action: onPress) {
			Text(label)
				.frame(minWidth: 0, maxWidth: .infinity)
				.font(Font.button)
				.padding()
				.foregroundColor(.error)
				.overlay(
					RoundedRectangle(cornerRadius: UIView.standardCornerRadius)
						.stroke(Color.error, lineWidth: 4)
				)
		}
		.frame(maxWidth: .infinity)
		.background(Color.componentColor)
		.cornerRadius(UIView.standardCornerRadius)
		.shadow(color: Color.black.opacity(0.2), radius: 5, y: 5)
		.disabled(disabled)
		.opacity(disabled ? 0.5 : 1)
	}
}

struct DangerButton_Previews: PreviewProvider {
	static var previews: some View {
		VStack{
			DangerButton(label: "Danger", disabled: false, onPress: {
				print("yo")
			})
			DangerButton(label: "Danger", disabled: true, onPress: {
				print("yo")
			})
		}
	}
}
