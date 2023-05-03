//
//  AddLocationPage.swift
//  voice-pick-frontend
//
//  Created by tama on 22/04/2023.
//

import SwiftUI

struct AddLocationPage: View {
	
	@EnvironmentObject var authService: AuthenticationService
	
	@State private var code: String = ""
	@State private var controlDigits: String = ""
	@State private var locationType: String = "PRODUCT"
	
	@State private var codeErrorMsg: String?
	@State private var controlDigitsErrorMsg: String?
	@State private var locationTypeErrorMsg: String?
	
	@State private var isColorEnabled: Bool = false
	
	@ObservedObject var requestService = RequestService()
	
	@State var showAlert = false;
	@State var errorMessage = "";
	@Environment(\.dismiss) private var dismiss
	
	@State var showBanner = false
	@State var bannerData = BannerModifier.BannerData(title: "Suksess", detail: "Lokasjonen ble lagt til", type: .Success)
	
	func handleSubmit() {
		var validForm = true
		resetErrorMessages()
		
		if code.isEmpty {
			validForm = false
			codeErrorMsg = "Ingen tomme felter tillatt"
		}
		
		let controlDigitNum = Int(controlDigits.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
		if (controlDigitNum <= 99 || controlDigitNum >= 1000) {
			validForm = false
			controlDigitsErrorMsg = "Må være et 3 siffer positivt tall"
		}
		
		if locationType.isEmpty {
			validForm = false
			locationTypeErrorMsg = ""
		}
		
		if validForm {
			let location = Location(code: code, controlDigits: controlDigitNum, locationType: locationType)
			addLocationRequest(location: location)
		}
	}
	
	func resetFields() {
		code = ""
		controlDigits = ""
	}
	
	func resetErrorMessages() {
		codeErrorMsg = nil
		controlDigitsErrorMsg = nil
		locationTypeErrorMsg = nil
	}
	
	var body: some View {
		NavigationView {
			VStack(alignment: .leading, spacing: 20) {
				AddLocationField(
					label: "Hyllekode",
					value: $code,
					errorMsg: $codeErrorMsg)
				AddLocationField(
					label: "Kontroll nummer",
					value: $controlDigits,
					errorMsg: $controlDigitsErrorMsg,
					type: .numberPad)
				.padding(.bottom)
				CustomDisclosureGroup(
					title: "Lokasjonstype",
					selectedValue: locationType,
					list: LocationType.allCases.map { $0.rawValue },
					action: { selectedType in
						locationType = selectedType
					},
					isColorEnabled: $isColorEnabled
				)
				Spacer()
				DefaultButton("Legg til lokasjon", disabled: false, onPress: {
					handleSubmit()
				})
			}
			.banner(data: $bannerData, show: $showBanner)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
			.background(Color.backgroundColor)
			.foregroundColor(Color.foregroundColor)
		}
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text("Legg til Lokasjon")
			}
			ToolbarItem(placement: .navigationBarLeading) {
				Button(action: {dismiss()}) {
					Label("Return", systemImage: "chevron.backward")
				}
			}
		}
		.foregroundColor(Color.black)
		.navigationBarTitleDisplayMode(.inline)
		.toolbarBackground(Color.traceLightYellow, for: .navigationBar)
		.toolbarBackground(.visible, for: .navigationBar)
		.navigationBarBackButtonHidden(true)
	}
	
	
	func addLocationRequest(location: Location) {
		requestService.post(path: "/locations", token: authService.accessToken, body: location, responseType: String.self, completion: { result in
			switch result {
			case .success(_):
				resetFields()
				bannerData.title = "Suksess"
				bannerData.detail = "Lokasjonen ble lagt til"
				bannerData.type = .Success
				showBanner = true
				break
			case .failure(let error as RequestError):
				handleError(errorCode: error.errorCode)
				bannerData.title = "Feil"
				bannerData.detail = error.localizedDescription
				bannerData.type = .Error
				showBanner = true
			default:
				break
			}
		})
	}
	
	/**
	 error handling
	 */
	func handleError(errorCode: Int) {
		switch errorCode {
		case 401:
			showAlert = true
			errorMessage = "Noe gikk galt, du har ikke nok rettigheter."
			break
		case 500:
			showAlert = true
			errorMessage = "Noe gikk galt med verifiseringen av en bruker."
			break
		default:
			showAlert = true;
			errorMessage = "Noe gikk galt, vennligst lukk applikasjonen og prøv på nytt, eller rapporter hendelsen."
			break
		}
	}
}

struct AddLocationField: View {
	let label: String
	@Binding var value: String
	@Binding var errorMsg: String?
	var type: UIKeyboardType = .default
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(label)
				.font(.headline)
			DefaultInput(inputLabel: label, text: $value, valid: true, keyboardType: type)
			if let errorMsg = errorMsg {
				Text(errorMsg)
					.foregroundColor(.red)
					.font(.caption)
			}
		}
	}
}


struct AddLocationPage_Previews: PreviewProvider {
	static var previews: some View {
		AddLocationPage()
	}
}
