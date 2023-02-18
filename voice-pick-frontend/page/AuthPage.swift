//
//  AuthPage.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 15/02/2023.
//

import SwiftUI

struct AuthPage: View {
	enum AuthMode {
		case login, signup
	}
	
	init() {
		self.authMode = AuthMode.login
	}
	
	@State var authMode: AuthMode;
	@State var emailValue = ""
	@State var passwordValue = ""
	@State var userIsAuthenticated = false;
	@State var submitted = false;
	
	/**
	 Swaps between sign up and log in mode for the form.
	 */
	func switchAuthMode() {
		if authMode == AuthMode.login {
			authMode = AuthMode.signup
		} else {
			authMode = AuthMode.login
		}
	}
	
	/**
	 Checks if the current input in the form is valid or not.
	 
	 - Returns: True if the form is valid, false if it is invalid.
	 */
	func validateForm() -> Bool {
		if !validateEmail() || !validatePassword() {
			return false
		}
		return true
	}
	
	func signIn() {
		submitted = true;
		if validateForm() {
			//TODO: send request to backend to sign in with credentials
			// if successful redirect to home page
			withAnimation {
				userIsAuthenticated = true
			}
		} else {
			//TODO: disable button
			//TODO: display error message
		}
	}
	
	func register() {
		//TODO: validate input
		submitted = true;
		if validateForm() {
			//TODO: send request to register
			withAnimation {
				// if successful: display verify email page
				userIsAuthenticated = true
			}
		} else {
			// disable button
			//TODO: display error message on failing field
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
	
	/**
	 - Returns: True if email is valid or the form is not submitted, false if the email is not valid and the form is submitted.
	 */
	func validateEmail() -> Bool {
		return Validator.shared.isValidEmail(emailValue) || !submitted
	}
	
	/**
	 - Returns: True if password is valid or the form is not submitted, false if the email is not valid and the form is submitted.
	 */
	func validatePassword() -> Bool {
		return Validator.shared.isValidPassword(passwordValue) || !submitted
	}
	
	var content: some View {
		VStack(spacing: 20) {
			VStack() {
				Text("TRACE").font(.guidelineHeading).foregroundColor(.traceLightYellow)
				Text("Voice Pick").font(.header1).foregroundColor(.foregroundColor).offset(y: -20)
			}
			Spacer()
			DefaultInput(inputLabel: "Email", isPassword: false, text: $emailValue, validator: validateEmail()).onChange(of: emailValue) { _ in
				if validateForm() {
					submitted = false
				}
			}
			DefaultInput(inputLabel: "Password", isPassword: true, text: $passwordValue, validator: validatePassword())
				.onChange(of: passwordValue) { _ in
					if validateForm() {
						submitted = false
					}
				}
			
			authMode == AuthMode.login ?
			DefaultButton("Sign in", disabled: !validateForm() && submitted, onPress: signIn)
			:
			DefaultButton("Sign up", disabled: !validateForm() && submitted, onPress: register)
			
			
			Text("Forgot password?").font(.label).frame(maxWidth: .infinity, alignment: .trailing)
			HStack {
				Text("Dont have an account?")
				Button("Sign up here", action: switchAuthMode)
					.buttonStyle(.plain)
					.underline()
			}
			.offset(y: 50)
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
