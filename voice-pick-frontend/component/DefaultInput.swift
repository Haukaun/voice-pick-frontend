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
	var validator: Bool
	
	var body: some View {
		let view = isPassword ? AnyView(SecureField(
			inputLabel,
			text: $text
		)):
		AnyView(TextField(
			inputLabel,
			text: $text
		))
		
		return view
			.fontWeight(.bold)
			.font(.button)
			.padding()
			.overlay(
				RoundedRectangle(cornerRadius: 5)
					.stroke(validator ? Color.borderColor : Color.error, lineWidth: 2)
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
			DefaultInput(inputLabel: "Email", isPassword: false, text: .constant("hello"), validator: true)
			DefaultInput(inputLabel: "Email", isPassword: false, text: .constant(""), validator: false)
		}
		.padding()
	}
}
