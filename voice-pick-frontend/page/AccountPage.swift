//
//  AccountPage.swift
//  voice-pick-frontend
//
//  Created by tama on 17/02/2023.
//

import SwiftUI
import AVFAudio
import AVFoundation

struct AccountPage: View {
	
	@ObservedObject var requestService = RequestService()
	@EnvironmentObject var authenticationService: AuthenticationService
	@StateObject var ttsService = TTSService.shared
	
	@State private var showVoiceAlert = false
	@State private var voiceErrorMessage = ""
    
    @State private var showWarningAlert = false
    @State private var warningAlertMessage = ""
    
	@State private var showImagePicker = false
	@State private var selectedImage = "profile-1"
	
    /**
        Handles the event when the "delete user" is pressed
     */
	func handleDeleteAccount() {
        warningAlertMessage = "Er du sikker på at du vil slette brukeren? Dette kan ikke omgjøres!"
        showWarningAlert = true
	}
    
    /**
        Deletes the user
     */
    func deleteUser() {
        requestService.delete(path: "/auth/users", token: authenticationService.accessToken, responseType: String.self, completion: { result in
            switch result {
            case .success(_):
                clearAuthTokens()
            case .failure(let error):
                print(error)

            }
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
			voiceErrorMessage = "Stemmen er ikke installert på denne enheten. Vennligst installer den manuelt på enheten din. \n \n Gå til Innstillinger > Tilgjengelighet > Opplest innhold > Stemmer > Engelsk og last ned Nathan og Evan."
			showVoiceAlert = true
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
		ZStack {
			VStack(alignment: .leading, spacing: 0) {
				Header(
					headerText: "Profil",
					rightButtons: [
						Button(action: {
							logout()}, label: {
								Image(systemName: "rectangle.portrait.and.arrow.right.fill")
							})
					]
				)
				ScrollView{
					HStack {
						Spacer()
						ZStack {
							Image(selectedImage)
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(width: 110, height: 110)
								.clipShape(Circle())
								.onTapGesture {
									showImagePicker = true
								}
							Circle()
								.fill(Color.traceLightYellow)
								.frame(width: 35, height: 35)
								.offset(x: 40, y: 40)
							Image(systemName: "plus")
								.foregroundColor(Color.foregroundColor)
								.offset(x: 40, y: 40)
						}
						Spacer()
					}
					HStack{
						Spacer()
						VStack {
							Title(authenticationService.userName)
							Paragraph("Profesjonell plukker")
								.opacity(0.3)
						}
						Spacer()
					}
					VStack (alignment: .trailing) {
						VStack {
							DisclosureGroup(content: {
								VStack {
									ForEach(Voice.allCases) { voice in
										voiceButton(title: voice.name) {
											selectVoice(voice: voice)
										}
										.padding(.horizontal, 2)
									}
								}.padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
							}, label: {
								HStack {
									Text("Valgt stemme: ")
									Text(ttsService.selectedVoice?.name ?? "Standard")
										.bold()
										.foregroundColor(Color.foregroundColor)
								}
							})
							.accentColor(.foregroundColor)
						}
						.padding(15)
						.background(Color.componentColor)
						.accentColor(.foregroundColor)
						.cornerRadius(UIView.standardCornerRadius)
						.shadow(color: Color.black.opacity(0.2), radius: 5, y: 5)
						Divider()
						DangerButton(label: "Forlat varehus", onPress: {
							
						})
						DangerButton(label: "Slett bruker", onPress: {
							handleDeleteAccount()
						})

					}
					.frame(maxHeight: .infinity)
					.padding(10)		
				}
				.padding(.top)
				.background(Color.backgroundColor)
				.alert("Stemme", isPresented: $showVoiceAlert, actions: {}, message: { Text(voiceErrorMessage)})
				.alert(isPresented: $showWarningAlert) {
						Alert(
							title: Text("Slett bruker"),
							message: Text(warningAlertMessage),
							primaryButton: .destructive(Text("Slett"), action: {
									deleteUser()
							}),
							secondaryButton: .cancel(Text("Avbryt"))
						)
				}
				.sheet(isPresented: $showImagePicker){
					ImagePicker(selectedImage: $selectedImage)
				}
			}
			if requestService.isLoading {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle())
					.scaleEffect(2)
					.frame(width: 100, height: 100)
					.background(Color.backgroundColor)
					.cornerRadius(20)
					.foregroundColor(.foregroundColor)
					.padding()
			}
		}
	}
}

struct AccountPage_Previews: PreviewProvider {
	static var previews: some View {
		AccountPage()
			.environmentObject(AuthenticationService())
			.environmentObject(TTSService())
	}
}
