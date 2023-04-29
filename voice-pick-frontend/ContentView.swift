//
//  ContentView.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 10/02/2023.
//

import SwiftUI
import Speech
import KeychainSwift
import SwiftUI

struct ContentView: View {
	enum ActiveView {
		case auth, verification, setupWarehouse, tabBar
	}
	
    @EnvironmentObject var authenticationService: AuthenticationService
    
	@State private var activeView: ActiveView = .auth
	
	var body: some View {
		VStack {
			if activeView == .auth {
				AuthPage()
			} else if activeView == .verification {
				VerificationPage()
			} else if activeView == .setupWarehouse {
				SetupWarehouse()
			} else if activeView == .tabBar {
				TabBar()
			}
		}
		.onAppear {
			updateActiveView()
		}
		.onChange(of: authenticationService.accessToken) { _ in
			withAnimation(.easeInOut(duration: 0.5)) {
				updateActiveView()
			}
		}
		.onChange(of: authenticationService.emailVerified) { _ in
			withAnimation(.easeInOut(duration: 0.5)) {
				updateActiveView()
			}
		}
		.onChange(of: authenticationService.warehouseId) { _ in
			withAnimation(.easeInOut(duration: 0.5)) {
				updateActiveView()
			}
		}
	}
	
	private func updateActiveView() {
		if authenticationService.accessToken.isEmpty {
			activeView = .auth
		} else if !authenticationService.emailVerified {
			activeView = .verification
		} else if authenticationService.warehouseId == nil {
			activeView = .setupWarehouse
		} else {
			activeView = .tabBar
		}
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

