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
	
	
	var body: some View {
		VStack {
			
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
