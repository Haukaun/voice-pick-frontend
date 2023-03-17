//
//  DefaultInput.swift
//  voice-pick-frontend
//
//  Created by tama on 14/02/2023.
//

import SwiftUI

struct DefaultInput: View {
	let inputLabel: String
	var isPassword: Bool = false
	@Binding public var text: String
	var valid: Bool
	
	var body: some View {
		let view = isPassword ? AnyView(SecureField(
			inputLabel,
			text: $text
		).autocorrectionDisabled(true)):
		AnyView(TextField(
			inputLabel,
			text: $text
		).autocorrectionDisabled(true))
		
		return view
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
			DefaultInput(inputLabel: "Email", isPassword: false, text: .constant("hello"), valid: true)
			DefaultInput(inputLabel: "Email", isPassword: false, text: .constant(""), valid: false)
		}
		.padding()
	}
}
