//  A wrapper page responsible for maintaining controller
//  over which pluck page to display
//
//  PluckPage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 16/02/2023.
//

import SwiftUI

struct PluckPage: View {
	
	@EnvironmentObject var authenticationService: AuthenticationService
	
	@ObservedObject private var pluckService = PluckService()
	@ObservedObject private var voiceService = VoiceService()
	
	var body: some View {
		VStack(spacing: 0) {
			if pluckService.activePage != .COMPLETE {
				Header(headerText: "Plukkliste")
			}
			switch pluckService.activePage {
			case .LOBBY:
				PluckLobby(token: authenticationService.accessToken)
					.transition(.backslide)
			case .INFO:
				PluckInfo()
					.transition(.backslide)
			case .LIST_VIEW:
				PluckListDisplay()
					.transition(.backslide)
			case .COMPLETE:
				PluckComplete()
					.transition(.backslide)
			case .DELIVERY:
				PluckFinish()
					.transition(.backslide)
			}
		}
		.onAppear {
			voiceService.requestSpeechAuthorization()
			voiceService.startRecording()
		}
		.onDisappear {
			voiceService.stopRecording()
		}
		.onChange(of: voiceService.transcription) { newValue in
			pluckService.doAction(
				keyword: newValue,
				fromVoice: true,
				token: authenticationService.accessToken
			)
		}
		.environmentObject(pluckService)
		.background(Color.backgroundColor)
	}
}

struct PluckPage_Previews: PreviewProvider {
	static var previews: some View {
		PluckPage()
	}
}
