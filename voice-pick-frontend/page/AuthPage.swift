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
            errorMessage = "Ugyldig e-post";
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
            errorMessage = "Noe gikk galt, er du sikker på at dette er riktig e-postadresse?"
            break
        case 500:
            showAlert = true
            errorMessage = "Noe gikk galt under sending av e-posten"
            break
        case 404:
            showAlert = true
            errorMessage = "Noe gikk galt, brukeren ble ikke funnet"
            break
        default:
            showAlert = true;
            errorMessage = "Noe gikk galt, vennligst avslutt applikasjonen og prøv igjen, eller rapporter en feil."
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
            Button("Glemt passord?") {
                sendResetPasswordMail()
            }
						.font(.label).frame(maxWidth: .infinity, alignment: .trailing)
						.foregroundColor(.foregroundColor)
			HStack {
				Text("Har du ikke en konto?")
				Button(authMode == AuthMode.signup ? "Logg inn her" : "Registrer deg her", action: switchAuthMode)
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
        .alert("Tilbakestill passord", isPresented: $showAlert, actions: {}, message: { Text(errorMessage)})
	}
}

struct AuthPage_Previews: PreviewProvider {
	static var previews: some View {
		AuthPage()
	}
}
