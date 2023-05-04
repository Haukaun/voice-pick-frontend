//
//  AuthForm.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 03/03/2023.
//

import SwiftUI
import KeychainSwift

struct AuthForm: View {
	
	@State var firstnameValue = ""
	@State var lastnameValue = ""
	@Binding var emailValue: String
	@State var passwordValue = ""
	
	@State var submitted = false;
	
	@State var showAlert = false;
	@State var errorMessage = "";
	
	@Binding var authMode: AuthMode
	
	@ObservedObject var requestService = RequestService()
	
	@EnvironmentObject var authenticationService: AuthenticationService
	
	/**
	 Validates the form based on which mode it is in.
	 
	 - Returns: True if the form is valid, false if it is invalid.
	 */
	func validateForm() -> Bool {
		if authMode == AuthMode.signup {
			if !validateEmail() || !validatePassword() || !validateFirstname() || !validateLastname() {
				return false
			}
			return true
		} else {
			if !validateEmail() || !validatePassword() {
				return false
			}
			return true
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
	
	func setUserInfo(_ userInfo: LoginResponse) {
		DispatchQueue.main.async {
			authenticationService.roles = userInfo.roles
			authenticationService.uuid = userInfo.uuid
			authenticationService.userName = userInfo.username
			authenticationService.email = userInfo.email
			authenticationService.accessToken = userInfo.accessToken
			authenticationService.refreshToken = userInfo.refreshToken
			authenticationService.emailVerified = userInfo.emailVerified
			authenticationService.warehouseId = userInfo.warehouse?.id
			authenticationService.warehouseName = userInfo.warehouse?.name ?? ""
			authenticationService.warehouseAddress = userInfo.warehouse?.address ?? ""
		}
	}
	
	/**
	 Sign the user in to the system.
	 */
	func signIn() {
		submitted = true;
		if validateForm() {
			let userInfo = UserInfo(email: emailValue, password: passwordValue)
			requestService.post(path: "/auth/login", body: userInfo, responseType: LoginResponse.self, completion: { result in
				switch result {
				case .success(let response):
					setUserInfo(response)
					break
				case .failure(let error as RequestError):
					handleError(errorCode: error.errorCode)
					break
				default:
					break
				}
			})
		}
	}
	
	
	/*
	 Error handling for user
	 */
	func handleError(errorCode: Int) {
		switch errorCode {
		case 401:
			showAlert = true
			errorMessage = "Feil brukernavn eller passord"
		case 409:
			showAlert = true;
			errorMessage = "En bruker med denne e-postadressen finnes allerede"
			break
		default:
			showAlert = true;
			errorMessage = "Noe gikk galt. Vennligst prøv igjen eller rapporter en feil."
			break
		}
	}
	
	
	
	/*
	 Register a new user.
	 */
	func register() {
		submitted = true;
		if validateForm() {
			let userInfo = UserInfo(
				firstName: firstnameValue,
				lastName: lastnameValue,
				email: emailValue,
				password: passwordValue
			)
			requestService.post(path: "/auth/signup", body: userInfo, responseType: String.self, completion: { result in
				switch result {
				case .success(_):
					authMode = AuthMode.login
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
		ZStack {
			VStack(spacing: 20) {
				if authMode == AuthMode.signup {
					DefaultInput(inputLabel: "Fornavn", text: $firstnameValue, valid: validateFirstname())
					DefaultInput(inputLabel: "Etternavn", text: $lastnameValue, valid: validateLastname())
				}
				DefaultInput(inputLabel: "E-post", text: $emailValue, valid: validateEmail()).onChange(of: emailValue) { _ in
					if validateForm() {
						submitted = false
					}
				}
				PasswordInput(value: $passwordValue, valid: validatePassword())
					.onChange(of: passwordValue) { _ in
						if validateForm() {
							submitted = false
						}
					}
				authMode == AuthMode.login ?
				DefaultButton("Logg inn", disabled: !validateForm() && submitted, onPress: signIn)
				:
				DefaultButton("Registrer", disabled: !validateForm() && submitted, onPress: register)
			}
			.alert(authMode == AuthMode.signup ? "Registrer" : "Logg inn", isPresented: $showAlert, actions: {}, message: { Text(errorMessage)})
			
			if requestService.isLoading {
				CustomProgressView()
			}
		}
		
	}
}

struct AuthForm_Previews: PreviewProvider {
	static var previews: some View {
		AuthForm(emailValue: .constant(""), authMode: .constant(AuthMode.signup))
			.padding(50)
	}
}
