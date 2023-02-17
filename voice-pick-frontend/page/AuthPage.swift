//
//  AuthPage.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 15/02/2023.
//

import SwiftUI

struct AuthPage: View {
	@State var email = "Email"
	@State var password = "Password"
	@State var buttonText = "Sign in"
	
	func switchAuthMode() {
		if (buttonText == "Sign in") {
			buttonText = "Sign up"
		} else {
			buttonText = "Sign in"
		}
	}
	
	var body: some View {
		VStack(spacing: 12) {
			VStack(spacing: -15) {
				Text("TRACE").font(.guidelineHeading).foregroundColor(.traceLightYellow)
				Text("Voice Pick").font(.header1).foregroundColor(.foregroundColor)
			}
			Spacer()
			DefaultInput(inputText: $email, isPassword: false)
			DefaultInput(inputText: $password, isPassword: true)
            DefaultButton(buttonText) {
                print("pressed")
            }
			Text("Forgot password?").font(.label).frame(maxWidth: .infinity, alignment: .trailing)
			HStack {
				Text("Dont have an account?")
				Text("Sign up here")
					.underline()
					.onTapGesture {
						switchAuthMode()
					}
			}
			.font(.label)
			Spacer()
			Footer()
		}
		.padding(50)
		.background(Color.backgroundColor)
	}
}

struct AuthPage_Previews: PreviewProvider {
	static var previews: some View {
		AuthPage()
	}
}
