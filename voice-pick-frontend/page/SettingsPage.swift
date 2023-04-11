//
//  SettingsPage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 16/03/2023.
//

import SwiftUI
import AVFAudio

struct SettingsPage: View {
	
	let requestService = RequestService()
	@EnvironmentObject var authenticationService: AuthenticationService
	@EnvironmentObject var ttsService: TTSService
	
	@State private var showAlert = false
	@State private var errorMessage = ""
	
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
	
	/**
	 Tries to logout a user based on the tokes for the currently logged in user
	 */
	func logout() {
		requestService.post(
			path: "/auth/signout",
			token: authenticationService.accessToken,
			body: TokenDto(token: authenticationService.refreshToken),
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
			authenticationService.accessToken = ""
			authenticationService.refreshToken = ""
			authenticationService.email = ""
			authenticationService.emailVerified = false
		}
	}
	
	
	/**
	 Sets the voice or shows alert with message.
	 */
	func selectVoice(voice: Voice) {
		if isVoiceAvailable(voice: voice) {
			ttsService.setVoice(voice: voice)
		} else {
			errorMessage = "Stemmen er ikke installert på denne enheten. Vennligst installer den manuelt på enheten din. \n \n Gå til Innstillinger > Tilgjengelighet > Opplest innhold > Stemmer > Engelsk og last ned Nathan og Evan."
			showAlert = true
		}
	}
	
	/**
	 Check if the voice is available.
	 */
	func isVoiceAvailable(voice: Voice) -> Bool {
		let avVoice = AVSpeechSynthesisVoice(identifier: voice.rawValue)
				return avVoice != nil
	}
	
	
	/**
	 Button for displaying the cargo
	 */
	func voiceButton(title: String, action: @escaping () -> Void) -> some View {
		Button(action: action) {
			Spacer()
			Text(title)
				.padding(15)
				.fontWeight(.bold)
				.font(.button)
				.foregroundColor(.snow)
			Spacer()
		}
		.background(Color.night)
		.cornerRadius(UIView.standardCornerRadius)
	}
	
	
	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			Header(headerText: "Instillinger")
			VStack(alignment: .leading, spacing: 30) {
				VStack {
					DisclosureGroup(content: {
						ScrollView {
							VStack {
								ForEach(Voice.allCases) { voice in
									voiceButton(title: voice.name) {
										selectVoice(voice: voice)
									}
									.padding(.horizontal, 2)
								}
							}.padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
						}
					}, label: {
						HStack {
							Text("Valgt stemme: ")
							Text(ttsService.selectedVoice?.name ?? "Standard")
								.bold()
								.foregroundColor(Color.foregroundColor)
						}
					})
					.accentColor(.mountain)
				}
				.padding(15)
				.background(Color.componentColor)
				.accentColor(.foregroundColor)
				.cornerRadius(UIView.standardCornerRadius)
				.shadow(color: Color.black.opacity(0.2), radius: 5, y: 5)
				Spacer()
				DefaultButton("Logout") {
					logout()
				}
				Divider()
				DangerButton(label: "Delete account", onPress: {
					deleteAccount()
				})
			}
			.frame(maxHeight: .infinity)
			.padding(10)
		}
		.padding(0)
		.background(Color.backgroundColor)
		.alert("Stemme", isPresented: $showAlert, actions: {}, message: { Text(errorMessage)})
	}
}

struct SettingsPage_Previews: PreviewProvider {
	static var previews: some View {
		SettingsPage()
			.environmentObject(AuthenticationService())
			.environmentObject(TTSService())
	}
}
