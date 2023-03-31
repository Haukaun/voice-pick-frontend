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
	
	@ObservedObject var authenticationService = AuthenticationService()
	
	var body: some View {
			if authenticationService.authToken != nil {
				if authenticationService.isEmailVerified != false {
							TabBar()
					} else {
							VerificationPage()
									.environmentObject(authenticationService)
					}
			} else {
					AuthPage()
							.environmentObject(authenticationService)
			}
	}

}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

