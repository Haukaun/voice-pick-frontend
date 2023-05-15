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
	@EnvironmentObject var voiceService: VoiceService
	@EnvironmentObject var pluckService: PluckService
	
	private let voiceLog = VoiceLog.shared
	
	/**
	 Toggle speech recognizer on and off.
	 */
	func toggleMute() {
		if pluckService.isMuted {
			pluckService.doAction(keyword: "listen", fromVoice: false)
		} else {
			pluckService.doAction(keyword: "mute", fromVoice: false)
		}
	}
	
	var body: some View {
		VStack(spacing: 0) {
			if pluckService.activePage != .COMPLETE {
				Header(
					headerText: "Plukkliste",
					rightButtons: [
						Button(action: {
							toggleMute()
						}, label: {
							Image(systemName: pluckService.isMuted ? "mic.slash.fill" : "mic.fill")
						}),
					]
				)
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
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				voiceService.startRecording()
				
				voiceService.onRecognizedTextChange = { result in
					pluckService.doAction(
						keyword: result,
						fromVoice: true,
						token: authenticationService.accessToken
					)
					voiceLog.addMessage(LogMessage(message: result, type: LogMessageType.INPUT))
				}
			}
		}
		.onDisappear {
			voiceService.stopRecording()
			voiceService.onRecognizedTextChange = nil
		}
		.background(Color.backgroundColor)
	}
}

struct PluckPage_Previews: PreviewProvider {
	static var previews: some View {
		PluckPage()
			.environmentObject(AuthenticationService())
	}
}
