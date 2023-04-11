//
//  DefaultInput.swift
//  voice-pick-frontend
//
//  Created by tama on 14/02/2023.
//

import SwiftUI

struct DefaultInput: View {
	let inputLabel: String
	@Binding public var text: String
	var valid: Bool
	var keyboardType: UIKeyboardType = .asciiCapable
	
	var body: some View {
		TextField(
			inputLabel,
			text: $text
		).autocorrectionDisabled(true)
			.keyboardType(keyboardType)
			.fontWeight(.bold)
			.font(.button)
			.padding()
			.overlay(
				RoundedRectangle(cornerRadius: 5)
					.stroke(valid ? Color.borderColor : Color.error, lineWidth: 2)
			)
			.foregroundColor(Color.mountain)
			.background(Color.componentColor)
			.cornerRadius(5)
			.shadow(color: Color.black.opacity(0.25) ,radius: 3, y: 4)
	}
}

struct DefaultInput_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			DefaultInput(inputLabel: "Email", text: .constant("hello"), valid: true)
			DefaultInput(inputLabel: "Email", text: .constant(""), valid: false)
			DefaultInput(inputLabel: "Phonenumber", text: .constant("123"), valid: true, keyboardType: .numberPad)
		}
		.padding()
	}
}

