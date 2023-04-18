//
//  ProductDetailsPage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 14/04/2023.
//

import SwiftUI

struct ProductDetailsPage: View {
	
	@State var isEditing = false
	
	let id: Int;
	@State var name: String
	@State var weight: Float
	@State var volume: Float
	@State var quantity: Int
	@State var type: ProductType
	@State var status: ProductStatus
	@State var location: String
	
	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Image(systemName: "pencil")
					.opacity(0)
				Spacer()
				SubTitle("Produkt detaljer")
				Spacer()
				Button(action: { isEditing.toggle() }) {
					Image(systemName: "pencil")
				}
				.foregroundColor(Color.foregroundColor)
			}
			Spacer()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding(20)
		.background(Color.backgroundColor)
	}
}

struct ProductDetailsPage_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			Text("yo")
		}
		.sheet(isPresented: .constant(true)) {
			ProductDetailsPage(
				id: 1,
				name: "Coca Cola",
				weight: 1.5,
				volume: 1.5,
				quantity: 10,
				type: ProductType.D_PACK,
				status: ProductStatus.READY,
				location: "H209")
		}
	}
}
