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
	
	@EnvironmentObject var authenticationService: AuthenticationService
	
	let requestService = RequestService()
	

	/*
	 Check if the given Verification code exists in backend
	 */
	func checkVerificationCode() {
		let emailVerificationCode = EmailVerificationCode(verificationCode: verificationCode, email: authenticationService.userEmail!)
		requestService.post(path: "/auth/check-verification-code", body: emailVerificationCode, responseType: Bool.self, completion: { result in
				switch result {
				case .success(let response):
					DispatchQueue.main.async {
						authenticationService.isEmailVerified = response
					}
					break
				case .failure(let error as RequestError):
					print(error)
					break
				default:
					break
				}
			})
	}
	
	
	var body: some View {
		VStack{
			ZStack{
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
					.font(.header2)
					.foregroundColor(.foregroundColor)
					.multilineTextAlignment(.center)
				DefaultInput(inputLabel: "Verify Email", isPassword: false, text: $verificationCode, valid: true)
				DefaultButton("Submit", onPress: {
					checkVerificationCode()
				})
			}
			.padding(10)
			Spacer()
			Footer()
		}
		.padding(50)
		.background(Color.backgroundColor)
		.onAppear{
			requestService.post(path: "/auth/verify-email", body: authenticationService.userEmail, responseType: String.self, completion: { result in
				switch result {
				case .success(_):
					break
				case .failure(let error as RequestError):
					print(error)
					break
				default:
					break
				}
			})
		}
	}
}

struct VerificaitonPage_Previews: PreviewProvider {
	static var previews: some View {
		VerificationPage()
	}
}
