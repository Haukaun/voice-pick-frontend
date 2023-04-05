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
        self.emailValue = ""
	}
	
    let requestService = RequestService()
    @State var authMode: AuthMode;
    @State var emailValue: String;
    @State var showAlert = false;
    @State var errorMessage = "";
	
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
    
    /*
     Send Email that will get its password reset
     */
    func sendResetPasswordMail(){
        if Validator.shared.isValidEmail(emailValue) {
            requestService.post(path: "/auth/reset-password", body: emailValue, responseType: String.self, completion: { result in
                switch result {
                case .success(let response):
                    print(response)
                    break
                case .failure(let error as RequestError):
                    handleError(errorCode: error.errorCode)
                    break
                default:
                    break
                }
            })
        } else {
            errorMessage = "Invalid Email";
            showAlert = true;
        }
    }
    
    /*
     Error handling
     */
    func handleError(errorCode: Int) {
        switch errorCode {
        case 400:
            showAlert = true
            errorMessage = "Something went wrong, are you sure this is the correct email?"
            break
        case 500:
            showAlert = true
            errorMessage = "Something went wrong while sending the email"
            break
        case 404:
            showAlert = true
            errorMessage = "Something went wrong, user not found"
            break
        default:
            showAlert = true;
            errorMessage = "Something went wrong, please exit the application and try again, or report a bug."
            break
        }
    }
	
	var body: some View {
		VStack {
			VStack() {
				Text("TRACE").font(.guidelineHeading).foregroundColor(.traceLightYellow)
				Text("Voice Pick").font(.header1).foregroundColor(.foregroundColor).offset(y: -20)
			}
			Spacer()
            AuthForm(emailValue: $emailValue, authMode: $authMode)
            Button("Forgot password?") {
                sendResetPasswordMail()
            }.font(.label).frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(.black)
			HStack {
				Text("Dont have an account?")
				Button(authMode == AuthMode.signup ? "Sign in here" : "Sign up here", action: switchAuthMode)
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
        .alert("Reset Password", isPresented: $showAlert, actions: {}, message: { Text(errorMessage)})
	}
}

struct AuthPage_Previews: PreviewProvider {
	static var previews: some View {
		AuthPage()
	}
}
