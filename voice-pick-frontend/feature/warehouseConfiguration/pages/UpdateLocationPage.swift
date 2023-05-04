//
//  UpdateLocationPage.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 27/04/2023.
//

import SwiftUI

struct UpdateLocationPage: View {
	
	let locationCode: String
	
	@State private var code: String
	@State private var controlDigits: String
	@State private var locationType: String
	@State private var products: [Product] = []
	@State private var pluckLists: [LocationPluckListResponse] = []
	@State private var codeErrorMsg: String?
	@State private var controlDigitErrorMsg: String?
	@State private var locationTypeErrorMsg: String?
	@State private var showingAlert = false
	@State var errorMessage = ""
	
	@State var showBanner = false
	@State var bannerData = BannerModifier.BannerData(title: "Suksess", detail: "Lokasjonen ble oppdatert", type: .Success)
	
	
	@EnvironmentObject var authService: AuthenticationService
	
	private let requestService = RequestService()
	
	func fetchProducts() {
		requestService.get(path: "/locations/\(code)/products", token: authService.accessToken, responseType: [Product].self) { result in
			switch result {
			case .success(let fetchedProducts):
				self.products = fetchedProducts
			case .failure(let error as RequestError):
				handleError(errorCode: error.errorCode)
			default:
				break
			}
		}
	}
	
	func fetchPluckLists() {
		requestService.get(path: "/locations/\(code)/pluck-lists", token: authService.accessToken, responseType: [LocationPluckListResponse].self) { result in
			switch result {
			case .success(let fetchedPluckLists):
				self.pluckLists = fetchedPluckLists
			case .failure(let error as RequestError):
				handleError(errorCode: error.errorCode)
			default:
				break
			}
		}
	}
	
	/**
	 Error handling
	 */
	func handleError(errorCode: Int) {
		switch errorCode {
		case 401:
			showingAlert = true
			errorMessage = "Noe gikk galt, du har ikke nok rettigheter."
			break
		case 404:
			// only happens if there are no products or pluck_lists in a location no need to show an alert in this case.
			break
		case 500:
			showingAlert = true
			errorMessage = "Denne lokasjonen er ugyldig!"
			break
		default:
			showingAlert = true;
			errorMessage = "Noe gikk galt, vennligst lukk applikasjonen og prøv på nytt, eller rapporter hendelsen."
			break
		}
	}
	
	init(location: Location, locationCode: String) {
		self.code = locationCode
		self.controlDigits = String(location.controlDigits)
		self.locationType = location.locationType
		self.locationCode = locationCode
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
				path: "/locations/\(locationCode)",
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
						handleError(errorCode: error.errorCode)
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
				}.onAppear {
					locationType == "PRODUCT" ? fetchProducts() : fetchPluckLists()
				}
				if (locationType == "PRODUCT" && products.count > 0){
					Spacer()
					HStack{
						Text("Vare")
							.bold()
						Spacer()
						Text("Antall")
							.bold()
					}
					List {
						ForEach(products, id: \.self) { product in
							HStack {
								Text(product.name)
								Spacer()
								Text("\(product.quantity)")
							}
						}
						.listRowBackground(Color.backgroundColor)
					}
					.listStyle(PlainListStyle())
					.scrollContentBackground(.hidden)
					.padding(-15)
				}
				else if (locationType == "PLUCK_LIST" && pluckLists.count > 0){
					Spacer()
					HStack{
						Text("Destinasjon")
							.bold()
						Spacer()
						Text("Rute")
							.bold()
					}
					List {
						ForEach(pluckLists, id: \.self) { pluckList in
							HStack {
								Text(pluckList.destination)
								Spacer()
								Text(pluckList.route)
							}
						}
						.listRowBackground(Color.backgroundColor)
					}
					.listStyle(PlainListStyle())
					.scrollContentBackground(.hidden)
					.padding(-15)
				} else {
					HStack{
						Text("Det finnes ingen data i denne lokajsonen")
							.bold()
					}
				}
				Spacer()
				DefaultButton("Oppdater lokasjon", disabled: false, onPress: {
					handleSubmit()
				})
			}
			.banner(data: $bannerData, show: $showBanner)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
			.background(Color.backgroundColor)
			.foregroundColor(Color.foregroundColor)
			.toolbar {
				ToolbarItem(placement: .principal) {
					Text("Oppdater lokasjon")
						.foregroundColor(.black)
				}
			}
			.foregroundColor(Color.black)
			.navigationBarTitleDisplayMode(.inline)
			.toolbarBackground(Color.traceLightYellow, for: .navigationBar)
			.toolbarBackground(.visible, for: .navigationBar)
		}
	}
}

struct UpdateLocationPage_Previews: PreviewProvider {
	
	
	static var previews: some View {
		UpdateLocationPage(location: Location(code: "H101", controlDigits: 123, locationType: "PRODUCT"), locationCode: "H110")
			.environmentObject(AuthenticationService())
	}
}
