//
//  ContentView.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 10/02/2023.
//

import SwiftUI
import Speech
import KeychainSwift
struct ContentView: View {
	
	@StateObject var authenticationService = AuthenticationService()
	
	var body: some View {
		if !authenticationService.accessToken.isEmpty {
			if authenticationService.emailVerified != false {
				TabBar()
					.environmentObject(authenticationService)
			} else {
				VerificationPage()
					.environmentObject(authenticationService)
					.transition(.backslide)
			}
		} else {
			AuthPage()
				.environmentObject(authenticationService)
				.transition(.backslide)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

