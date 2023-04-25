//
//  ScannerView.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 28/03/2023.
//

import SwiftUI
import CodeScanner

struct AddProductPage: View {
	@State private var isShowingScanner = false
	
	@State private var productName: String = "N/A"
	@State private var weight: String = "N/A"
	@State private var volume: String = "N/A"
	@State private var quantity: String = "N/A"
	@State private var type: String = "N/A"
	@State private var location: String = "N/A"
	
	@State private var productNameErrorMsg: String?
	@State private var weightErrorMsg: String?
	@State private var volumeErrorMsg: String?
	@State private var quantityErrorMsg: String?
	@State private var typeErrorMsg: String?
	@State private var locationErrorMsg: String?
	
	@State var showAlert = false
	@State var errorMessage = ""
	
	@State var showBanner = false
	@State var bannerData = BannerModifier.BannerData(title: "Suksess", detail: "Produktet ble lagt til", type: .Success)
	
	
	@EnvironmentObject var authService: AuthenticationService
	
	private let requestService = RequestService()
	
	/**
	 Handles the event when the scanner picks up a barcode
	 
	 - Parameters:
	 -	result: the result from the scan
	 */
	func handleScan(result: Result<ScanResult, ScanError>) {
		isShowingScanner = false;
		switch result {
		case .success(let result):
			fetchProductInfo(result.string)
		case .failure(_):
			errorMessage = "Noe gikk galt med scanning. Prøv på nytt"
			showAlert = true
		}
	}
	
	/**
	 Fetches info of a product based on a gtin
	 
	 - Parameters:
	 -	gtin: of the product to fetch info of
	 */
	func fetchProductInfo(_ gtin: String) {
		resetErrorMessages()
		
		requestService.get(path: "/products/\(gtin)", responseType: PalletInfoDto.self, completion: { result in
			switch result {
			case .success(let productInfo):
				self.productName = productInfo.productName
				self.weight = String(productInfo.productWeight)
				self.volume = String(productInfo.productVolume)
				self.quantity = String(productInfo.quantity)
				self.type = "\(productInfo.type)"
			case .failure(_):
				errorMessage = "Registrerted gtin \(gtin) fra strekkode, men fant ikke produkt med denne gtin. Prøv på nytt"
				showAlert = true
			}
		})
	}
	
	/**
	 Handles the event
	 */
	func handleSubmit() {
		var validForm = true
		resetErrorMessages()
		
		if (productName.isEmpty || productName == "N/A") {
			validForm = false
			productNameErrorMsg = "Ingen tomme felter tillatt"
		}
		
		let weightNum = Double(weight.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
		if (weightNum <= 0) {
			validForm = false
			weightErrorMsg = "Må være et positivt tall"
		}
		
		let volumeNum = Double(volume.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
		if (volumeNum <= 0) {
			validForm = false
			volumeErrorMsg = "Må være et positivt tall"
		}
		
		let quantityInt = Int(quantity.trimmingCharacters(in: .whitespacesAndNewlines)) ?? -1
		if (quantityInt < 0) {
			validForm = false
			quantityErrorMsg = "Må være et tall"
		}
		
		if (type.isEmpty || type == "N/A") {
			validForm = false
			typeErrorMsg = "Ingen tomme felter tillatt"
		}
		
		if (location.isEmpty || location == "N/A") {
			validForm = false
			locationErrorMsg = "Ingen tomme felter tillatt"
		}
		
		if (validForm) {
			requestService.post(
				path: "/products",
				token: authService.accessToken,
				body: AddProductDto(
					name: productName,
					location: location,
					weight: weightNum,
					volume: volumeNum,
					quantity: quantityInt,
					type: ProductType(rawValue: type) ?? ProductType.D_PACK),
				responseType: String.self,
				completion: { result in
					switch result {
					case .success(_):
						bannerData.title = "Suksess"
						bannerData.detail = "Produktet ble lagt til"
						bannerData.type = .Success
						showBanner = true
					case .failure(let error):
						bannerData.title = "Feil"
						bannerData.detail = error.localizedDescription
						bannerData.type = .Error
						showBanner = true
					}
				}
			)
		}
		
	}
	
	
	func resetErrorMessages() {
		productNameErrorMsg = nil
		weightErrorMsg = nil
		volumeErrorMsg = nil
		quantityErrorMsg = nil
		typeErrorMsg = nil
		locationErrorMsg = nil
	}
	
	var body: some View {
		NavigationView {
			VStack(spacing: 0) {
				Header(
					headerText: "Legg til produkt",
					rightButtons: [
						Button(action: {isShowingScanner = true}, label: {
							Image(systemName: "barcode.viewfinder")
						})
					]
				)
				VStack(alignment: .leading, spacing: 20) {
					AddProductField(
						label: "Produktnavn",
						value: $productName,
						errorMsg: $productNameErrorMsg)
					AddProductField(
						label: "Vekt",
						value: $weight,
						errorMsg: $weightErrorMsg,
						type: .asciiCapableNumberPad)
					AddProductField(
						label: "Volum",
						value: $volume,
						errorMsg: $volumeErrorMsg,
						type: .decimalPad)
					AddProductField(
						label: "Antall",
						value: $quantity,
						errorMsg: $quantityErrorMsg,
						type: .decimalPad)
					AddProductField(
						label: "Type",
						value: $type,
						errorMsg: $typeErrorMsg)
					AddProductField(
						label: "Plassering",
						value: $location,
						errorMsg: $locationErrorMsg)
					Spacer()
					DefaultButton("Legg til produkt", disabled: false, onPress: {
						handleSubmit()
					})
				}
				
				.banner(data: $bannerData, show: $showBanner)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.padding(10)
				.background(Color.backgroundColor)
			}
			.toolbar {
				ToolbarItem(placement: .principal) {
					Text("Produkter")
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: { isShowingScanner = true }) {
						Image(systemName: "barcode.viewfinder")
					}
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbarBackground(Color.traceLightYellow, for: .navigationBar)
			.toolbarBackground(.visible, for: .navigationBar)
			.sheet(isPresented: $isShowingScanner) {
				CodeScannerView(codeTypes: [.upce, .ean8, .ean13], showViewfinder: true, simulatedData: "7021110120818", completion: handleScan)
			}
			.alert("Feil", isPresented: $showAlert, actions: {}, message: { Text(errorMessage) })
		}
	}
}
	
	struct AddProductPage_Previews: PreviewProvider {
		static var previews: some View {
			AddProductPage()
				.environmentObject(AuthenticationService())
		}
	}