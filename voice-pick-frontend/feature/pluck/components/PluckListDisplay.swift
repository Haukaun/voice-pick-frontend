//
//  PluckListDisplay.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/02/2023.
//

import SwiftUI

struct PluckListDisplay: View {
	@State private var products: [ProductCard] = [
		ProductCard(varer: "Cola", lokasjon: "H-23", antall: 34, vekt: 45, pakkeType: "F-pack", status: "Klar", showArrowsAndCounter: false),
		ProductCard(varer: "Cola", lokasjon: "H-23", antall: 34, vekt: 45, pakkeType: "F-pack", status: "Klar", showArrowsAndCounter: false),
		ProductCard(varer: "Cola", lokasjon: "H-23", antall: 34, vekt: 45, pakkeType: "F-pack", status: "Klar", showArrowsAndCounter: false),
		ProductCard(varer: "Cola", lokasjon: "H-23", antall: 34, vekt: 45, pakkeType: "F-pack", status: "Klar", showArrowsAndCounter: false)
	]
	
	var body: some View {
		NavigationView {
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
				}
				.onMove(perform: onMove)
				.listRowInsets(EdgeInsets())
				.frame(width: .infinity)
				.padding(5)
				.listRowSeparator(.hidden)
			}.listStyle(PlainListStyle())
				.frame(maxWidth: .infinity)
				.navigationBarItems(leading: EditButton())
		}
	}
	private func onMove(source: IndexSet, destination: Int){
		products.move(fromOffsets: source, toOffset: destination)
	}
}

struct PluckListDisplay_Previews: PreviewProvider {
	static var previews: some View {
		PluckListDisplay()
	}
}
