//
//  TabBar.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/02/2023.
//

import SwiftUI

struct TabBar: View {
	
	var body: some View {
		TabView {
			PluckPage()
				.tabItem {
					Label("Menu", systemImage: "house")
				}
			AccountPage()
				.tabItem {
					Label("Search", systemImage: "magnifyingglass")
				}
			AuthPage()
				.tabItem {
					Label("Profile", systemImage: "person")
				}
		}
	}
}

struct TabBar_Previews: PreviewProvider {
	static var previews: some View {
		TabBar()
	}
}
