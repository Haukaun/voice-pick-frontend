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
	
	@State var showAlert = false;
	@State var errorMessage = "";
	
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
	
	func handleError(errorCode: Int) {
		switch errorCode {
		case 409:
			showAlert = true;
			errorMessage = "User with this email already exists"
			break
		default:
			showAlert = true;
			errorMessage = "Something went wrong, please exit the application and try again, or report a bug."
			break
		}
	}
	
	func register() {
		submitted = true;
		if validateForm() {
			let userInfo = UserInfo(
				firstname: firstnameValue,
				lastname: lastnameValue,
				email: emailValue,
				password: passwordValue
			)
			requestService.post(path: "/auth/signup", body: userInfo, responseType: String.self, completion: { result in
				switch result {
				case .success(_):
					withAnimation {
						userIsAuthenticated = true
					}
					break
				case .failure(let error as RequestError):
					handleError(errorCode: error.errorCode)
					break
				case .failure(_):
					break
				}
			})
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
		.alert("Sign up error", isPresented: $showAlert, actions: {}, message: { Text(errorMessage)})
	}
}

struct AuthForm_Previews: PreviewProvider {
	static var previews: some View {
		AuthForm(authMode: .constant(AuthMode.signup))
			.padding(50)
	}
}
