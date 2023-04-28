//
//  UpdateLocationPage.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 27/04/2023.
//

import SwiftUI

struct UpdateLocationPage: View {
	
	@State private var code: String
	@State private var controlDigits: String
	@State private var locationType: String
	
	@State private var codeErrorMsg: String?
	@State private var controlDigitErrorMsg: String?
	@State private var locationTypeErrorMsg: String?
	
	@State var showBanner = false
	@State var bannerData = BannerModifier.BannerData(title: "Suksess", detail: "Lokasjonen ble oppdatert", type: .Success)
	
	
	@EnvironmentObject var authService: AuthenticationService
	
	private let requestService = RequestService()
	
	init(location: Location) {
		self.code = location.code
		self.controlDigits = String(location.controlDigits)
		self.locationType = location.locationType
	}
	
	func handleSubmit() {
		
		var validForm = true
		resetErrorMessages()
		
		if code.isEmpty {
			validForm = false
			codeErrorMsg = "Ingen tomme felter tillatt"
		}
		
		if locationType.isEmpty {
			validForm = false
			locationTypeErrorMsg = "Ingen tomme felter tillatt"
		}
		
		
		let controlDigitNum = Int(controlDigits.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
		if (controlDigitNum <= 99 || controlDigitNum >= 1000) {
			validForm = false
			controlDigitErrorMsg = "Må være et 3 siffer positivt tall"
		}
		
		if (validForm) {
			requestService.patch(
				path: "/locations/\(code)",
				token: authService.accessToken,
				body: Location(
				code: code,
				controlDigits: controlDigitNum,
				locationType: locationType
				),
				responseType: String.self,
				completion: { result in
					switch result {
					case .success(_):
						bannerData.title = "Suksess"
						bannerData.detail = "Produktet ble oppdatert"
						bannerData.type = .Success
						showBanner = true
					case .failure(let error as RequestError):
						bannerData.title = "Feil"
						bannerData.detail = error.localizedDescription
						bannerData.type = .Error
						showBanner = true
					default:
						break
					}
				}
			)
		}
	}
	
	/**
	 Resets all of the errormesages.
	 */
	func resetErrorMessages() {
		controlDigitErrorMsg = nil
		codeErrorMsg = nil
	}
	
	
	var body: some View {
		NavigationView {
			VStack(spacing: 0) {
				VStack(alignment: .leading, spacing: 20) {
					ProductField(
						label: "Lokasjonskode",
						value: $code,
						errorMsg: $codeErrorMsg)
					ProductField(
						label: "Kontrollsiffer",
						value: $controlDigits,
						errorMsg: $controlDigitErrorMsg)
					VStack (alignment: .leading){
						Text("Lokasjonstype")
						Text(locationType)
							.bold()
					}
					Spacer()
					DefaultButton("Oppdater lokasjon", disabled: false, onPress: {
						handleSubmit()
					})
				}
				.banner(data: $bannerData, show: $showBanner)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.padding(15)
				.background(Color.backgroundColor)
			}
			.toolbar {
				ToolbarItem(placement: .principal) {
					Text("Oppdater lokasjon")
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbarBackground(Color.traceLightYellow, for: .navigationBar)
			.toolbarBackground(.visible, for: .navigationBar)
		}
	}
}

struct UpdateLocationPage_Previews: PreviewProvider {
	
	
	static var previews: some View {
		UpdateLocationPage(location: Location(code: "H101", controlDigits: 123, locationType: "PRODUCT"))
	}
}
