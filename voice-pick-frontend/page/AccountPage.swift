//
//  AccountPage.swift
//  voice-pick-frontend
//
//  Created by tama on 17/02/2023.
//

import SwiftUI
struct AccountPage: View {
	
	@EnvironmentObject var authService: AuthenticationService
	
	let requestService = RequestService()
	
	/**
	 Tries to logout a user based on the tokes for the currently logged in user
	 */
	func logout() {
		requestService.post(
			path: "/auth/signout",
			token: authService.accessToken,
			body: TokenDto(token: authService.refreshToken),
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
			authService.accessToken = ""
			authService.refreshToken = ""
			authService.email = ""
			authService.emailVerified = false
		}
	}
	
	var body: some View {
		VStack {
			DefaultButton("Logout") {
				logout()
			}
		}
		.padding(5)
		.background(Color.backgroundColor)
	}
	
}

struct AccountPage_Previews: PreviewProvider {
	static var previews: some View {
		AccountPage()
	}
}
