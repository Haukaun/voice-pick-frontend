//
//  PluckListDisplay.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/02/2023.
//

import SwiftUI

struct PluckListDisplay: View {
	let products: [ProductCard] = [
		ProductCard(varer: "Cola", lokasjon: "H-23", antall: 34, vekt: 45, pakkeType: "F-pack", status: "Klar"),
		ProductCard(varer: "Cola", lokasjon: "H-23", antall: 34, vekt: 45, pakkeType: "F-pack", status: "Klar"),
		ProductCard(varer: "Cola", lokasjon: "H-23", antall: 34, vekt: 45, pakkeType: "F-pack", status: "Klar"),
		ProductCard(varer: "Cola", lokasjon: "H-23", antall: 34, vekt: 45, pakkeType: "F-pack", status: "Klar")
	]
	
	var body: some View {
		List {
			ForEach(products, id: \.self) { product in
				product
					.swipeActions(edge: .trailing, content:{
						Button{
							print("Ankara")
						} label: {
							Label("Svipe venstre for å fullføre" , systemImage: "checkmark.circle.fill")
						}
						.tint(.success)
					})
			}.listRowInsets(EdgeInsets())
				.frame(width: .infinity)
				.padding(5)
				.listRowSeparator(.hidden)
		}.listStyle(PlainListStyle())
			.frame(maxWidth: .infinity)
	}
}

struct PluckListDisplay_Previews: PreviewProvider {
	static var previews: some View {
		PluckListDisplay()
	}
}
