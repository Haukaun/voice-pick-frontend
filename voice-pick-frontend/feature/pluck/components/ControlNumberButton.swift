//
//  ControlNumberButton.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 22/02/2023.
//

import SwiftUI


/*
 ControlNumberButton to register correct number of a product. Wrong answer will display red background on the button.
 */
struct ControlNumberButton: View {
		let possibleNumber: String
		var onPress: () -> Void
		var wrongAnswer: Bool
		
		var body: some View {
				Button(action: onPress) {
						Spacer()
						Text("\(possibleNumber)")
								.padding(15)
								.fontWeight(.bold)
								.font(.button)
								.foregroundColor(.snow)
						Spacer()
				}
				.background(
						wrongAnswer
								? Color.error
								: Color.night
				)
				.cornerRadius(UIView.standardCornerRadius)
		}
}

struct ControlNumberButton_Previews: PreviewProvider {
    static var previews: some View {
			HStack (spacing: 10){
				ControlNumberButton(possibleNumber: "345", onPress: {}, wrongAnswer: false)
			}
    }
}
