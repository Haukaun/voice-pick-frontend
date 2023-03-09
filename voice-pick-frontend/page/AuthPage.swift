//
//  AuthPage.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 15/02/2023.
//

import SwiftUI

struct AuthPage: View {
	init() {
		self.authMode = AuthMode.login
	}
	
	@State var authMode: AuthMode;
	
	@State var userIsAuthenticated = false;
	@State var submitted = false;
	
	let requestService = RequestService()
	
	/**
	 Swaps between sign up and log in mode for the form.
	 */
	func switchAuthMode() {
		if authMode == AuthMode.login {
			withAnimation {
				authMode = AuthMode.signup
			}
		} else {
			withAnimation {
				authMode = AuthMode.login
			}
		}
	}
	
	var body: some View {
		if userIsAuthenticated && authMode == AuthMode.login {
			PluckPage()
				.transition(.slide)
		} else if (authMode == AuthMode.signup && userIsAuthenticated) {
			VerificaitonPage()
				.transition(.slide)
		} else {
			content
				.transition(.slide)
		}
	}
	
	var content: some View {
		VStack {
			VStack() {
				Text("TRACE").font(.guidelineHeading).foregroundColor(.traceLightYellow)
				Text("Voice Pick").font(.header1).foregroundColor(.foregroundColor).offset(y: -20)
			}
			Spacer()
			AuthForm(authMode: $authMode)
			Text("Forgot password?").font(.label).frame(maxWidth: .infinity, alignment: .trailing)
			HStack {
				Text("Dont have an account?")
				Button("Sign up here", action: switchAuthMode)
					.buttonStyle(.plain)
					.underline()
			}
			.offset(y: 30)
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
