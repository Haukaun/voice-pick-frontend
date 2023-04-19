//
//  ProductPage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 12/04/2023.
//

import SwiftUI

struct ProductPage: View {
	
	let products: [Product] = [
		.init(
			id: 1,
			name: "Coca Cola",
			weight: 1.5,
			volume: 1.5,
			quantity: 10,
			type: ProductType.D_PACK,
			status: ProductStatus.READY,
			location: .init(
				code: "H209", controlDigits: 476, locationType: "")),
		.init(
			id: 1,
			name: "Pepsi max",
			weight: 1.5,
			volume: 1.5,
			quantity: 10,
			type: ProductType.D_PACK,
			status: ProductStatus.READY,
			location: .init(
				code: "H215",
				controlDigits: 479, locationType: ""))]
	
	@State var searchField: String = ""
	
	@State var selectedProduct: Product?
	@State var isSheetPresent = false
	
	var body: some View {
		NavigationView {
			VStack {
				DefaultInput(inputLabel: "Søk...", text: $searchField, valid: true)
				ForEach(products, id: \.self) { product in
					Card {
						HStack {
							Text(product.name)
							Spacer()
							Image(systemName: "chevron.up")
						}
						.frame(maxWidth: .infinity)
					}
					.onTapGesture {
						selectedProduct = product
						isSheetPresent.toggle()
					}
				}
				Spacer()
			}
			.padding(5)
		}
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text("Produkter")
			}
			ToolbarItem(placement: .navigationBarTrailing) {
				NavigationLink(destination: AddProductPage()) {
					Image(systemName: "plus")
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.toolbarBackground(Color.traceLightYellow, for: .navigationBar)
		.toolbarBackground(.visible, for: .navigationBar)
		.sheet(isPresented: $isSheetPresent) {
			if (selectedProduct != nil) {
				ProductDetailsPage(
					id: selectedProduct!.id,
					name: selectedProduct!.name,
					weight: selectedProduct!.weight,
					volume: selectedProduct!.volume,
					quantity: selectedProduct!.quantity,
					type: selectedProduct!.type,
					status: selectedProduct!.status,
					location: selectedProduct!.location.code
				)
			} else {
				Text("Error")
			}
		}
	}
}

struct ProductPage_Previews: PreviewProvider {
	static var previews: some View {
		ProductPage()
	}
}
