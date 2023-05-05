//
//  PluckCardDetail.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 12/04/2023.
//

import SwiftUI

struct PluckCardDetail: View {
	
	@State var pluck: Pluck
	
	@EnvironmentObject var pluckService: PluckService
	
	
	private func amountPlucked() -> Int {
		return pluckService.pluckList?.plucks.first(where: { $0.id == self.pluck.id } )?.amountPlucked ?? 0
	}
	
	
	var body: some View {
		ZStack {
			Image("Pallet")
				.scaledToFit()
				.opacity(0.75)
				.colorMultiply(.traceDarkYellow)
			VStack {
				VStack (alignment: .leading, spacing: 15) {
					VStack (alignment: .leading) {
						Paragraph("Antall:")
						Text("\(pluck.amount)")
							.font(.header2)
					}
					VStack (alignment: .leading) {
						Paragraph("Antall plukket:")
						Text("\(amountPlucked())")
							.font(.header2)
					}
					VStack (alignment: .leading) {
						Paragraph("Beholdning:")
						Text("\(pluck.product.quantity)")
							.font(.header2)
					}
					VStack(alignment: .leading) {
						Paragraph("Lokasjon:")
						Text(pluck.product.location?.code ?? "")
							.font(.header2)
					}
					VStack(alignment: .leading) {
						Paragraph("ProductType:")
						Text("\(pluck.product.type.rawValue)")
							.font(.header2)
					}
					VStack(alignment: .leading) {
						Paragraph("Produkt:")
						Text(pluck.product.name)
							.font(.header2)
					}
					VStack (alignment: .leading) {
						Paragraph("Volum:")
						Text("\(pluck.product.volume) m³")
							.font(.header2)
					}
					VStack (alignment: .leading) {
						Paragraph("Vekt:")
						Text("\(pluck.product.weight) kg")
							.font(.header2)
					}
					VStack(alignment: .leading) {
						Paragraph("Opprettet:")
						Text(pluck.createdAt)
							.font(.header2)
					}
				}
			}
			.background(
				RoundedRectangle(cornerRadius: 8)
					.fill(Color.backgroundColor)
					.shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
					.opacity(0.8)
					.frame(width: 350, height: 600)
			)
		}
	}
}


struct PluckCardDetail_Previews: PreviewProvider {
	
	static let location1 = Location(code: "P345", controlDigits: 123, locationType: "PRODUCT")
	
	static let product2 = Product(id: 2, name: "Coca-Cola", weight: 1.0, volume: 1.5, quantity: 5, type: .F_PACK, status: .EMPTY, location: location1)
	
	static let pluck1 = Pluck(id: 1, product: product2, amount: 2, amountPlucked: 0, createdAt: "2023-04-12T12:00:00", confirmedAt: nil, pluckedAt: nil)
	
	static var previews: some View {
		PluckCardDetail(pluck: pluck1)
			.environmentObject(PluckService())
	}
}
