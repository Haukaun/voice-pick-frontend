//
//  PasswordInput.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 16/03/2023.
//

import SwiftUI

struct PasswordInput: View {
	
    var placeholder: String = "Passord"
	@State var showPassword = false
	@Binding var value: String
	var valid: Bool
	
	var body: some View {
		HStack {
			showPassword
				? AnyView(TextField(placeholder, text: $value))
				: AnyView(SecureField(placeholder, text: $value))
			Button(action: {
				showPassword = !showPassword
			}) {
				Image(systemName: showPassword ? "eye" : "eye.slash")
			}
		}
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

struct PasswordInput_Previews: PreviewProvider {
	static var previews: some View {
		PasswordInput(value: .constant("Cheerio"), valid: true)
	}
}
