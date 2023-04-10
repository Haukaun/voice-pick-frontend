//
//  VerificaitonPage.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 15/02/2023.
//

import SwiftUI

struct VerificationPage: View {
	var buttonText = "Resend Email"
	
	@State var verificationCode = ""
	@State var timeRemaining = 0
	
	@State var showAlert = false;
	@State var errorMessage = "";
	
	@EnvironmentObject var authenticationService: AuthenticationService
	
	let requestService = RequestService()
	
	
	/*
	 Check if the given Verification code exists in backend
	 */
	func checkVerificationCode() {
		let emailVerificationCode = EmailVerificationCode(verificationCode: verificationCode, email: authenticationService.email)
		requestService.post(
			path: "/auth/check-verification-code",
			token: authenticationService.accessToken,
			body: emailVerificationCode,
			responseType: Bool.self,
			completion: { result in
				switch result {
				case .success(let response):
					DispatchQueue.main.async {
						authenticationService.emailVerified = response
					}
					break
				case .failure(let error as RequestError):
					handleError(errorCode: error.errorCode)
					break
				default:
					break
				}
			})
	}
	
	/*
	 Start timer for button
	 */
	
	func starTimer(duration: Int){
		timeRemaining = duration
		Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
			if timeRemaining > 0 {
				timeRemaining -= 1
			} else {
				timer.invalidate()
			}
		}
	}
	
	/*
	 Send Email with verificaiton code
	 */
	
	func sendVerificationCode(){
		requestService.post(path: "/auth/verify-email", body: authenticationService.email, responseType: String.self, completion: { result in
			switch result {
			case .success(_):
				break
			case .failure(let error as RequestError):
				handleError(errorCode: error.errorCode)
				break
			default:
				break
			}
		})
	}
	
	/**
	 Error handling
	 */
	func handleError(errorCode: Int) {
		switch errorCode {
		case 404:
			showAlert = true
			errorMessage = "Verificaiton code was not found. Please press resend button and try again."
			break
		case 500:
			showAlert = true
			errorMessage = "Something went wrong, with verifying the user."
			break
		default:
			showAlert = true;
			errorMessage = "Something went wrong, please exit the application and try again, or report a bug."
			break
		}
	}
	
	/**
	 Logs out the user from the application
	 */
	func logout() {
		requestService.post(
			path: "/auth/signout",
			token: authenticationService.accessToken,
			body: TokenDto(token: authenticationService.refreshToken),
			responseType: String.self,
			completion: { result in
				switch result {
				case .failure(let error as RequestError):
					// TODO: Handle error correctly
					if (error.errorCode == 401) {
						clearAuthTokens()
					}
					print(error)
				case .success(_):
					clearAuthTokens()
				case .failure(let error):
					print(error)
				}
			})
	}
	
	/**
	 Clears all stored tokens
	 */
	func clearAuthTokens() {
		DispatchQueue.main.async {
			authenticationService.accessToken = ""
			authenticationService.refreshToken = ""
			authenticationService.email = ""
			authenticationService.emailVerified = false
		}
	}
	
	var body: some View {
		NavigationView {
			VStack {
				ZStack {
					Image("Tracefavicon")
						.resizable()
						.frame(width: 120, height: 120)
						.opacity(0.05)
					VStack (spacing: -20){
						Text("TRACE").font(.guidelineHeading).foregroundColor(.traceLightYellow)
						Text("Voice pick").font(.header1).foregroundColor(.foregroundColor)
					}
				}
				Spacer()
				Group {
					Text("Email verification code sent to submitted email address. Please check your spam folder.")
						.foregroundColor(.foregroundColor)
						.multilineTextAlignment(.center)
					VStack(spacing: 10) {
						DefaultInput(inputLabel: "Verify Email", isPassword: false, text: $verificationCode, valid: true)
						DefaultButton("Submit", onPress: {
							checkVerificationCode()
						})
						DefaultButton(timeRemaining == 0 ? "Resend Email" : "\(timeRemaining)", disabled: timeRemaining > 0 , onPress:{
							if timeRemaining == 0 {
								sendVerificationCode()
								starTimer(duration: 20)
							}
						})
						Button("Log out", action: {
							logout()
						})
						.buttonStyle(.plain)
						.underline()
					}
				}
				.padding(10)
				Spacer()
				Footer()
			}
			.padding(50)
			.background(Color.backgroundColor)
			.onAppear {
				sendVerificationCode()
				starTimer(duration: 20)
			}
		}
		.alert("Verification", isPresented: $showAlert, actions: {}, message: { Text(errorMessage)})
	}
}

struct VerificaitonPage_Previews: PreviewProvider {
	static var previews: some View {
		VerificationPage()
	}
}
