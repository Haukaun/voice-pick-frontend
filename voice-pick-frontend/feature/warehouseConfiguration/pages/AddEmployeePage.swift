//
//  AddEmployeePage.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 24/04/2023.
//

import SwiftUI

struct AddEmployeePage: View {
	
	@ObservedObject var requestService = RequestService()
	
	@EnvironmentObject var authenticationService: AuthenticationService
	
	@Environment(\.dismiss) private var dismiss
	
	@State var userToInvite = ""
	
	@State var errorMessage = ""
	@State var showAlert = false
	
	@State var showBanner = false
	@State var bannerData = BannerModifier.BannerData(title: "Suksess", detail: "Brukeren ble invitert", type: .Success)
	
	func inviteUser() {
		requestService.post(path: "/warehouse/invite", token: authenticationService.accessToken, body: userToInvite, responseType: String.self, completion: { result in
			switch result {
			case .success(_):
				showBanner = true
			case .failure(let error as RequestError):
				handleError(error.errorCode)
			default:
				errorMessage = "Noe gikk galt. Start appen på nytt."
				showAlert = true
			}
		})
	}
	
	func handleError(_ errorCode: Int) {
		switch errorCode {
		case 404:
			errorMessage = "Du har ikke et varehus, eller mottakeren finnes ikke."
			showAlert = true
		case 401:
			errorMessage = "Du er ikke autorisert til å invitere brukere."
			showAlert = true
		case 500:
			errorMessage = "Noe gikk galt. Start appen på nytt."
			showAlert = true
		default:
			errorMessage = "Noe gikk galt. Start appen på nytt."
			showAlert = true
		}
	}
	
	var body: some View {
		ZStack {
			VStack(alignment: .leading) {
				Spacer()
				DefaultInput(inputLabel: "Email", text: $userToInvite, valid: true)
				DefaultButton("Inviter", onPress: inviteUser)
					.disabled(requestService.isLoading)
				Spacer()
			}
			.padding(15)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button(action: {dismiss()}) {
						Label("Return", systemImage: "chevron.backward")
					}
				}
				
				ToolbarItem(placement: .principal) {
					Text("Legg til ansatte")
				}
			}
			.background(Color.backgroundColor)
			.navigationBarBackButtonHidden(true)
			.foregroundColor(Color.black)
			.navigationBarTitleDisplayMode(.inline)
			.toolbarBackground(Color.traceLightYellow, for: .navigationBar)
			.toolbarBackground(.visible, for: .navigationBar)
			if requestService.isLoading {
				CustomProgressView()
			}
		}
		.banner(data: $bannerData, show: $showBanner)
		.alert("Error", isPresented: $showAlert, actions: {}, message: { Text(errorMessage) })
	}
}

struct AddEmployeePage_Previews: PreviewProvider {
	static var previews: some View {
		AddEmployeePage()
	}
}

