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
	
	@State private var numberOfPlucks: Int = 0
	
	@State private var showVoiceAlert = false
	@State private var voiceErrorMessage = ""
	
	@State private var showWarningAlert = false
	@State private var warningTitle = ""
	@State private var warningAlertMessage = ""
	@State private var warningActionLabel = ""
	@State private var warningAction: (() -> Void)?
	
	@State private var showImagePicker = false
	@State private var selectedImage = "profile-1"
	
	@State private var isColorEnabled: Bool = true
	
	/**
	 Handles the event when the "delete user" is pressed
	 */
	func handleDeleteAccount() {
		warningTitle = "Slett bruker"
		warningAlertMessage = "Er du sikker på at du vil slette brukeren? Dette kan ikke omgjøres!"
		warningActionLabel = "Slett"
		warningAction = deleteUser
		showWarningAlert = true
	}
	
	/**
	 Deletes the user
	 */
	func deleteUser() {
		requestService.delete(path: "/auth/users", token: authenticationService.accessToken, responseType: String.self, completion: { result in
			switch result {
			case .success(_):
				authenticationService.logout()
			case .failure(let error):
				print(error)
				
			}
		})
	}
	
	/**
	 Handles the event when "leave warehouse" is pressed
	 */
	func handleLeaveWarehouse() {
		warningTitle = "Forlat varehus"
		warningAlertMessage = "Er du sikker på at du vil forlate varehuset? Du vil ikke lengre ha tilgang med mindre du blir invitert på nytt"
		warningActionLabel = "Forlat"
		warningAction = leaveWarehouse
		showWarningAlert = true
	}
	
	func leaveWarehouse() {
		requestService.delete(path: "/warehouse/leave", token: authenticationService.accessToken, responseType: String.self, completion: { result in
			switch result {
			case .success(_):
				authenticationService.clearWarehouse()
			case .failure(let error):
				print(error)
				
			}
		})
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
	
	private var pluckerRank: String {
			switch numberOfPlucks {
			case 0..<1000:
					return "Nybegynner plukker"
			case 1000..<2000:
					return "Mid plukker"
			case 2000..<5000:
					return "Erfaren plukker"
			case 5000..<10000:
					return "Ekspert plukker"
			case 10000..<30000:
					return "Profesjonell plukker"
			case 30000...:
				return "Wall-E"
			default:
				return "Standard plukker"
			}
	}

	var body: some View {
		NavigationView {
			ZStack {
				VStack(spacing: 0) {
					Header(
						headerText: "Profil",
						rightButtons: [
							Button(action: {
								authenticationService.logout()
							}, label: {
								Image(systemName: "rectangle.portrait.and.arrow.right.fill")
							})
						]
					)
					ScrollView {
						HStack {
							Spacer()
							ZStack {
								ProfilePictureView(imageName: $selectedImage)
									.onTapGesture {
										showImagePicker = true
									}
								Circle()
									.fill(Color.traceLightYellow)
									.frame(width: 30, height: 30)
									.offset(x: 40, y: 40)
								Image(systemName: "plus")
									.foregroundColor(Color.black)
									.offset(x: 40, y: 40)
							}
							Spacer()
						}
						.padding(.top)
						Spacer()
						VStack {
							Title(authenticationService.userName)
							Paragraph(pluckerRank)
								.opacity(0.3)
						}
						.padding(.bottom)
						VStack (alignment: .leading, spacing: 20) {
							VStack (alignment: .leading) {
								Text("Stemme innstillinger:")
									.padding(.bottom)
									.font(.bodyBold)
								Card {
									HStack {
										Text("Lyd")
											.font(Font.customBody)
										Spacer()
										Text("\(Int(ttsService.volume * 100))%")
											.font(Font.bodyBold)
											.foregroundColor(.gray)
									}
									Slider(value: $ttsService.volume, in: 0...1, step: 0.1, onEditingChanged: { _ in
										ttsService.setVolume(volume: ttsService.volume)
									})
									.accentColor(.traceLightYellow)
									HStack {
										Text("Hastighet")
											.font(Font.customBody)
										Spacer()
										Text("\(Int(ttsService.rate * 100))%")
											.font(.bodyBold)
											.foregroundColor(.gray)
									}
									Slider(value: $ttsService.rate, in: 0...1, step: 0.05, onEditingChanged: { _ in
										ttsService.setRate(rate: ttsService.rate)
									})
									.accentColor(.traceLightYellow)
								}
							}
							VStack (alignment: .leading ,spacing: 20) {
								CustomDisclosureGroup(
									title: "Valgt stemme",
									selectedValue: ttsService.selectedVoice?.name ?? "Standard",
									list: Voice.allCases.map { $0.name },
									action: { selectedVoiceName in
										if let selectedVoice = Voice.allCases.first(where: { $0.name == selectedVoiceName }) {
											selectVoice(voice: selectedVoice)
										}
									},
									isColorEnabled: $isColorEnabled
								)
								.padding(.bottom)
								Divider()
								Text("Bruker innstillinger:")
									.font(.bodyBold)
								NavigationLink(destination: ChangePasswordPage()) {
									HStack {
										Image(systemName: "key.fill")
										Text("Endre passord")
										Spacer()
										Image(systemName: "chevron.right")
									}
									.foregroundColor(.foregroundColor)
									.frame(maxWidth: .infinity)
									.padding()
									.background(Color.componentColor)
									.cornerRadius(5)
									.shadow(color: Color.black.opacity(0.2), radius: 5, y: 5)
								}
								.padding(.bottom)
								Divider()
							}
							HStack {
								Text("Farlig sone")
									.font(.bodyBold)
								Image(systemName: "exclamationmark.triangle.fill")
							}
							.foregroundColor(.red)
							DangerButton(label: "Forlat varehus", onPress: {
								handleLeaveWarehouse()
							})
							DangerButton(label: "Slett bruker", onPress: {
								handleDeleteAccount()
							})
						}
						.padding(UIView.defaultPadding)
					}
					.background(Color.backgroundColor)
					.alert("Stemme", isPresented: $showVoiceAlert, actions: {}, message: { Text(voiceErrorMessage)})
					.alert(isPresented: $showWarningAlert) {
						Alert(
							title: Text(warningTitle),
							message: Text(warningAlertMessage),
							primaryButton: .destructive(Text(warningActionLabel), action: {
								warningAction!()
							}),
							secondaryButton: .cancel(Text("Avbryt"))
						)
					}
					.sheet(isPresented: $showImagePicker){
						ImagePicker(selectedImage: $selectedImage)
					}
					.onAppear {
						requestService.get(path: "/pluck-lists/users/\(authenticationService.uuid)",token: authenticationService.accessToken, responseType: Int.self, completion: { result in
							switch result {
							case .success(let pluckCount):
								numberOfPlucks = pluckCount
								break
							case .failure(let error as RequestError):
								print(error.errorCode)
							default:
								break
							}
						})
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
		.accentColor(Color.night)
	}
}

struct AccountPage_Previews: PreviewProvider {
	static var previews: some View {
		AccountPage()
			.environmentObject(AuthenticationService())
			.environmentObject(TTSService())
	}
}
