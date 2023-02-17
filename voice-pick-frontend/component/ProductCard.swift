//
//  ProductCard.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/02/2023.
//

import SwiftUI



struct ProductCard: View, Hashable {
	
	let varer: String
	let lokasjon: String
	let antall: Int
	let vekt: Double
	let pakkeType: String
	let status: String
	
	var body: some View {
		Card() {
			VStack(alignment: .leading) {
				VStack(alignment: .leading){
					Paragraph("Vare")
					Paragraph("\(varer)")
						.bold()
				}
				HStack(spacing: 25) {
					VStack (alignment: .leading){
						Paragraph("Lokasjon")
						Paragraph("\(lokasjon)")
							.bold()
					}
					VStack (alignment: .leading){
						Paragraph("Antall")
						Paragraph("\(antall)")
							.bold()
					}
					VStack (alignment: .leading){
						Paragraph("Vekt")
						Paragraph("\(vekt)")
							.bold()
					}
					VStack (alignment: .leading){
						Paragraph("Type")
						Paragraph("\(pakkeType)")
							.bold()
					}
					VStack(alignment: .leading){
						Paragraph("Status")
						Paragraph("\(status)")
							.bold()
					}
				}
			}
		}
	}
}

struct ProductCard_Previews: PreviewProvider {
	static var previews: some View {
		ProductCard(varer: "Cola", lokasjon: "H-23", antall: 34, vekt: 45, pakkeType: "F-pack", status: "Klar")
	}
}
