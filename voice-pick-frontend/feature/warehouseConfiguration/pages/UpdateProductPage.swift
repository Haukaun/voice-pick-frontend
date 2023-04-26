//
//  ProductDetailsPage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 14/04/2023.
//

import SwiftUI

struct UpdateProductPage: View {
	
	var product: ProductDto
	
	@State private var isShowingScanner = false
	
	
	@State private var productName: String
	@State private var weight: String
	@State private var volume: String
	@State private var quantity: String
	@State private var type: ProductType.RawValue
	@State private var status: ProductStatus.RawValue
	@State private var location: String
	
	@State private var productNameErrorMsg: String?
	@State private var weightErrorMsg: String?
	@State private var volumeErrorMsg: String?
	@State private var quantityErrorMsg: String?
	@State private var typeErrorMsg: String?
	@State private var locationErrorMsg: String?
	@State private var statusErrorMsg: String?
	
	
	@State var showAlert = false
	@State var errorMessage = ""
	
	@State var showBanner = false
	@State var bannerData = BannerModifier.BannerData(title: "Suksess", detail: "Produktet ble oppdatert", type: .Success)
	
	@EnvironmentObject var authService: AuthenticationService
	
	private let requestService = RequestService()
	
	init(product: ProductDto) {
		self.product = product
		productName = product.name
		weight = String(product.weight)
		volume = String(product.volume)
		quantity = String(product.quantity)
		type = product.type.rawValue
		status = product.status.rawValue
		location = product.location?.code ?? ""
	}
	
	/**
	 Handles the event
	 */
	func handleSubmit() {
		
		print(location)
		
		var validForm = true
		resetErrorMessages()
		
		
		let weightNum = Double(weight.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
		if weightNum <= 0{
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
		
		if (type.isEmpty) {
			validForm = false
			typeErrorMsg = "Ingen tomme felter tillatt"
		}
		
		if (status.isEmpty) {
			validForm = false
			locationErrorMsg = "Ingen tomme felter tillatt"
		}
		
		if (validForm) {
			requestService.patch(
				path: "/products/\(product.id)",
				token: authService.accessToken,
				body: SaveProductDto(
					name: productName,
					weight: weightNum,
					volume: volumeNum,
					quantity: quantityInt,
					type: ProductType(rawValue: type) ?? ProductType.D_PACK,
					status: ProductStatus(rawValue: status) ?? ProductStatus.READY,
					locationCode: location),
				responseType: String.self,
				completion: { result in
					switch result {
					case .success(_):
						bannerData.title = "Suksess"
						bannerData.detail = "Produktet ble oppdatert"
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
	
	/**
	 Resets all of the errormesages.
	 */
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
				VStack(alignment: .leading, spacing: 20) {
					ProductField(
						label: "Produktnavn",
						value: $productName,
						errorMsg: $productNameErrorMsg)
					ProductField(
						label: "Vekt",
						value: $weight,
						errorMsg: $weightErrorMsg,
						type: .asciiCapableNumberPad)
					ProductField(
						label: "Volum",
						value: $volume,
						errorMsg: $volumeErrorMsg,
						type: .decimalPad)
					ProductField(
						label: "Antall",
						value: $quantity,
						errorMsg: $quantityErrorMsg,
						type: .decimalPad)
					ProductField(
						label: "Plassering",
						value: $location,
						errorMsg: $locationErrorMsg)
					CustomDisclosureGroup(
							title: "Valgt status:",
							value: status,
							list: ProductStatus.allCases.map { $0.rawValue }
					) { selectedStatus in
							status = selectedStatus
					}
					CustomDisclosureGroup(
							title: "Valgt type:",
							value: type,
							list: ProductType.allCases.map { $0.rawValue }
					) { selectedType in
							type = selectedType
					}
					Spacer()
					DefaultButton("Oppdater produkt", disabled: false, onPress: {
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
					Text("Oppdater produkt")
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
			.alert("Feil", isPresented: $showAlert, actions: {}, message: { Text(errorMessage) })
		}
	}
}

struct ProductDetailsPage_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			Text("yo")
		}
		.sheet(isPresented: .constant(true)) {
			UpdateProductPage(product: ProductDto(id: 1, name: "Ankakra", weight: 34, volume: 34, quantity: 34, type: ProductType.D_PACK, status: ProductStatus.READY, location: Location(code: "123", controlDigits: 123, locationType: "M456")))
		}
	}
}
