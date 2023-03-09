//
//  AuthForm.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 03/03/2023.
//

import SwiftUI

struct AuthForm: View {
	
	@State var firstnameValue = ""
	@State var lastnameValue = ""
	@State var emailValue = ""
	@State var passwordValue = ""
	
	@State var userIsAuthenticated = false;
	@State var submitted = false;
	
	@Binding var authMode: AuthMode
	
	let requestService = RequestService()
	
	/**
	 Checks if the current input in the form is valid or not.
	 
	 - Returns: True if the form is valid, false if it is invalid.
	 */
	func validateForm() -> Bool {
		if !validateEmail() || !validatePassword() || !validateFirstname() || !validateLastname() {
			return false
		}
		return true
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
	
	/**
	 - Returns: True if firstname is valid or the form is not submitted, false if the email is not valid and the form is submitted,
	 */
	func validateFirstname() -> Bool {
		return Validator.shared.isValidFirstname(firstnameValue) || !submitted
	}
	
	/**
	 - Returns: True if the lastname is valid or t he form is not submitted, false if the email is not valid and the form is submitted.
	 */
	func validateLastname() -> Bool {
		return Validator.shared.isValidLastname(lastnameValue) || !submitted
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
			let userInfo = UserInfo(
				firstname: firstnameValue,
				lastname: lastnameValue,
				email: emailValue,
				password: passwordValue
			)
			requestService.post(path: "/auth/signup", body: userInfo, responseType: String.self, completion: { result in
				switch result {
				case .success(let response):
					print(response.description)
					break
				case .failure(let error):
					print(error.localizedDescription)
					break
				}
			})
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
		VStack(spacing: 20) {
			if authMode == AuthMode.signup {
				DefaultInput(inputLabel: "Firstname", text: $firstnameValue, validator: validateFirstname())
				DefaultInput(inputLabel: "Lastname", text: $lastnameValue, validator: validateLastname())
			}
			DefaultInput(inputLabel: "Email", text: $emailValue, validator: validateEmail()).onChange(of: emailValue) { _ in
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
		}
	}
}

struct AuthForm_Previews: PreviewProvider {
	static var previews: some View {
		AuthForm(authMode: .constant(AuthMode.signup))
			.padding(50)
	}
}
