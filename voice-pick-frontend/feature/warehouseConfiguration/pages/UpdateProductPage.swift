//
//  ProductDetailsPage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 14/04/2023.
//

import SwiftUI

struct UpdateProductPage: View {
	
	let productId: Int
	
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
	
	@State private var isColorEnabled: Bool = false
	
	@State var showBanner = false
	@State var bannerData = BannerModifier.BannerData(title: "Suksess", detail: "Produktet ble oppdatert", type: .Success)
	
	@EnvironmentObject var authService: AuthenticationService
	
	private let requestService = RequestService()
	
	init(product: Product) {
		self.productId = product.id
		self.productName = product.name
		self.weight = String(product.weight)
		self.volume = String(product.volume)
		self.quantity = String(product.quantity)
		self.type = product.type.rawValue
		self.status = product.status.rawValue
		self.location = product.location?.code ?? ""
	}
	
	/**
	 Handles the event
	 */
	func handleSubmit() {
		
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
				path: "/products/\(productId)",
				token: authService.accessToken,
				body: SaveProductDto(
					name: productName,
					weight: weightNum,
					volume: volumeNum,
					quantity: quantityInt,
					type: ProductType(rawValue: type) ?? ProductType.D_PACK,
					status: ProductStatus(rawValue: status) ?? ProductStatus.EMPTY,
					locationCode: location),
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
					.padding(.bottom)
					CustomDisclosureGroup(
						title: "Valgt type:",
						selectedValue: type,
						list: ProductType.allCases.map { $0.rawValue },
						action: { selectedType in
							type = selectedType
						},
						isColorEnabled: $isColorEnabled
					)
					VStack(alignment: .leading) {
						Text("Status")
						Text(status)
							.bold()
					}
					Spacer()
					DefaultButton("Oppdater produkt", disabled: false, onPress: {
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
					Text("Oppdater produkt")
						.foregroundColor(.black)
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: { isShowingScanner = true }) {
						Image(systemName: "barcode.viewfinder")
					}
				}
			}
            .foregroundColor(Color.black)
			.navigationBarTitleDisplayMode(.inline)
			.toolbarBackground(Color.traceLightYellow, for: .navigationBar)
			.toolbarBackground(.visible, for: .navigationBar)
		}
	}
}

struct ProductDetailsPage_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			Text("yo")
		}
		.sheet(isPresented: .constant(true)) {
			UpdateProductPage(product: Product(id: 1, name: "Ankakra", weight: 34, volume: 34, quantity: 34, type: ProductType.D_PACK, status: ProductStatus.READY, location: Location(code: "123", controlDigits: 123, locationType: "M456")))
		}
	}
}
