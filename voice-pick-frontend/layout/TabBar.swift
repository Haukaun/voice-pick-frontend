//
//  TabBar.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/02/2023.
//

import SwiftUI

struct TabBar: View {
	
	@EnvironmentObject var authenticationService: AuthenticationService
	@EnvironmentObject var ttsService: TTSService
	var body: some View {
		TabView {
			PluckPage()
				.tabItem {
					Label("Menu", systemImage: "house")
				}
				.environmentObject(authenticationService)
			AddProductPage()
				.tabItem {
					Label("Add product", systemImage: "plus.app.fill")
				}
			AccountPage()
				.tabItem {
					Label("Profile", systemImage: "person")
				}
		}
	}
}

struct TabBar_Previews: PreviewProvider {
	static var previews: some View {
		TabBar()
			.environmentObject(AuthenticationService())
			.environmentObject(TTSService())
	}
}
