//
//  ImagePicker.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/04/2023.
//

import SwiftUI

struct ImagePicker: View {
	var images: [String] = ["profile-1", "profile-2", "profile-3", "profile-4", "profile-5", "profile-6", "profile-7", "profile-8", "profile-9", "profile-10", "profile-11", "profile-12", "profile-13", "profile-14", "profile-15", "profile-16", "profile-17", "profile-18", "profile-19", "profile-20", "profile-21"]
	
	@Environment(\.dismiss) private var dismiss
	
	@EnvironmentObject var authenticationService: AuthenticationService
	@StateObject var requestService = RequestService()
	
	func setProfilePicture(_ profilePictureName: String) {
		print(profilePictureName)
		let profilePicture = ProfilePictureDto(pictureName: profilePictureName)
		requestService.patch(path: "/users/\(authenticationService.uuid)/profile-picture", token: authenticationService.accessToken, body: profilePicture, responseType: String.self, completion: { result in
			switch result {
			case .success(let response):
				// set in keychain
				DispatchQueue.main.async {
					authenticationService.profilePictureName = profilePictureName
				}
				dismiss()
				print(response)
			case .failure(let error as RequestError):
				print(error.errorCode)
			default:
				print("balla")
			}
		})
	}
	
	
	private let gridItems = [
		GridItem(.flexible()),
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	
	var body: some View {
		ZStack {
			VStack {
				Spacer()
				VStack{
					Title("Velg profilbilde")
				}
				VStack {
					ScrollView {
						LazyVGrid(columns: gridItems, spacing: 20) {
							ForEach(images, id: \.self) { image in
								ProfilePictureView(imageName: .constant(image))
									.onTapGesture {
										// send request
										setProfilePicture(image)
									}
							}
						}
						.padding()
					}
				}
			}
			.background(Color.backgroundColor)
			if requestService.isLoading {
				CustomProgressView()
			}
		}
	}
}



struct ImagePicker_Previews: PreviewProvider {
	static var previews: some View {
		ImagePicker()
	}
}
