//
//  SettingsPage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 16/03/2023.
//

import SwiftUI

struct SettingsPage: View {
	
	let requestService = RequestService()
	@EnvironmentObject var authenticationService: AuthenticationService
	
	func deleteAccount() {
		requestService.delete(
			path: "/users",
			token: authenticationService.accessToken,
			body: TokenRequest(token: authenticationService.accessToken),
			responseType: String.self,
			completion: { result in
				print(result)
			})
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Header(headerText: "Instillinger")
			VStack(alignment: .leading) {
				DangerButton(label: "Delete account", onPress: {
					deleteAccount()
				})
				Spacer()
			}
			.frame(maxHeight: .infinity)
			.padding(10)
		}
		.padding(0)
		.background(Color.backgroundColor)
	}
}

struct SettingsPage_Previews: PreviewProvider {
	static var previews: some View {
		SettingsPage()
			.environmentObject(AuthenticationService())
	}
}
