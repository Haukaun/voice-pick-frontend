//
//  DetailedEmployeePage.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 27/04/2023.
//

import SwiftUI

struct DetailedEmployeePage: View {
	
	@EnvironmentObject var authenticationService: AuthenticationService
	@StateObject var requestService = RequestService()
	
	@State var employee: User
	@State var showAlert = false
	@State var bannerData = BannerModifier.BannerData(title: "Feil", detail: "Noe gikk galt, start appen på nytt.", type: .Error)
	@State var showBanner = false
	
	func userIsLeader() -> Bool {
		return employee.roles.first(where: { $0.type == RoleType.LEADER }) != nil
	}
	
	func handleError(_ errorCode: Int) {
		switch errorCode {
		case 400:
			bannerData.detail = "Kunne ikke legge til rolle."
		default:
			break
		}
		showBanner = true
	}
	
	func demoteUser() {
		requestService.delete(path: "/auth/users/\(employee.uuid)/roles/leader", token: authenticationService.accessToken, responseType: User.self, completion: { result in
			switch result {
			case .success(let userWithNewRoles):
				withAnimation {
					employee = userWithNewRoles
				}
			case .failure(let error as RequestError):
				handleError(error.errorCode)
			default:
				bannerData.detail = "Noe gikk galt. Start appen på nytt."
				showBanner = true
			}
		})
	}
	
	func promoteUser() {
		requestService.post(path: "/auth/users/\(employee.uuid)/roles/leader", token: authenticationService.accessToken, responseType: User.self, completion: { result in
			switch result {
			case .success(let userWithNewRoles):
				withAnimation {
					employee = userWithNewRoles
				}
			case .failure(let error as RequestError):
				handleError(error.errorCode)
			default:
				bannerData.detail = "Noe gikk galt. Start appen på nytt."
				showBanner = true
			}
		})
	}
	
	var body: some View {
		ZStack {
			VStack {
				Spacer()
				ProfilePictureView(imageName: .constant(employee.profilePictureName ?? "profile-1"))
				Title("\(employee.firstName) \(employee.lastName)")
				Paragraph("\(employee.email)")
				if userIsLeader() {
					Button(action: {
						showAlert = true
					}) {
						Card(padding: 10) {
							HStack {
								Text("Leder")
								Image(systemName: "xmark")
							}
							.foregroundColor(.foregroundColor)
						}
					}
				}
				Spacer()
				DefaultButton("Forfrem til Leder", disabled: userIsLeader(), onPress: promoteUser)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.padding(10)
			.background(Color.backgroundColor)
			if requestService.isLoading {
				CustomProgressView()
			}
		}
		.alert("Advarsel", isPresented: $showAlert, actions: {
			Button(role: .cancel) {} label: {
				Text("Avbryt")
			}
			Button(role: .destructive) {
				demoteUser()
			} label: {
				Text("OK")
			}
		}, message: {
			Text("Er du sikker på at du vil degradere brukeren? Personen vil ikke lenger ha tilgang til leder funksjonalitet.")
		})
	}
}

struct DetailedEmployeePage_Previews: PreviewProvider {
	static var previews: some View {
		DetailedEmployeePage(employee: User(uuid: "123", firstName: "Ola", lastName: "Nordmann", email: "ola.nordmann@123.no", roles: [RoleDto(id: 1, type: RoleType.USER)], profilePictureName: "picture-1"))
			.environmentObject(AuthenticationService())
	}
}
