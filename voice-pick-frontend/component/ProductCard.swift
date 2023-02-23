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
	let showArrowsAndCounter: Bool
	
	var body: some View {
		Card() {
			if (showArrowsAndCounter) {
				HStack{
					Image(systemName: "arrowshape.left.fill")
					Spacer()
					Paragraph("1/7")
					Spacer()
					Image(systemName: "arrowshape.right.fill")
					
				}
				Image("Tracefavicon")
					.frame(width: 100, height: 100)
			}
			
			VStack(alignment: .leading) {
				VStack(alignment: .leading){
					Paragraph("Vare")
						.lineLimit(1)
						.truncationMode(.tail)
					Paragraph("\(varer)")
						.lineLimit(1)
						.truncationMode(.tail)
						.bold()
						.padding(.bottom)
				}
				HStack(spacing: 25) {
					VStack (alignment: .leading){
						Paragraph("Lokasjon")
							.lineLimit(1)
							.truncationMode(.tail)
						Paragraph("\(lokasjon)")
							.lineLimit(1)
							.truncationMode(.tail)
							.bold()
					}
					VStack (alignment: .leading){
						Paragraph("Antall")
							.lineLimit(1)
							.truncationMode(.tail)
						Paragraph("\(antall)")
							.lineLimit(1)
							.truncationMode(.tail)
							.bold()
					}
					VStack (alignment: .leading){
						Paragraph("Vekt")
							.lineLimit(1)
							.truncationMode(.tail)
						Paragraph("\(vekt)")
							.lineLimit(1)
							.truncationMode(.tail)
							.bold()
					}
					VStack (alignment: .leading){
						Paragraph("Type")
							.lineLimit(1)
							.truncationMode(.tail)
						Paragraph("\(pakkeType)")
							.lineLimit(1)
							.truncationMode(.tail)
							.bold()
					}
					VStack(alignment: .leading){
						Paragraph("Status")
							.lineLimit(1)
							.truncationMode(.tail)
						Paragraph("\(status)")
							.lineLimit(1)
							.truncationMode(.tail)
							.bold()
					}
				}
			}
		}
	}
}

struct ProductCard_Previews: PreviewProvider {
	static var previews: some View {
		ProductCard(varer: "Cola", lokasjon: "H-23", antall: 34, vekt: 45, pakkeType: "F-pack", status: "Klar", showArrowsAndCounter: false)
	}
}
