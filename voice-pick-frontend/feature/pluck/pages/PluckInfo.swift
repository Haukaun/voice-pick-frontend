//
//  PluckInfo.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 16/02/2023.
//

import SwiftUI

struct PluckInfo: View {
	
	var cargoCarriers: [CargoCarrier]
	
	@EnvironmentObject var pluckService: PluckPageService
	
	let next: () -> Void
	
	
	var body: some View {
		VStack() {
			Card {
				VStack(spacing: 24) {
					HStack(alignment: .top) {
						VStack(alignment: .leading) {
							DefaultLabel("Rute")
							Title(pluckService.pluckList!.route)
							Title(pluckService.pluckList!.destination)
						}
						Spacer()
						VStack(alignment: .leading) {
							DefaultLabel("ma - 05:30")
							DefaultLabel("ma - 11:15")
						}
					}
					HStack {
						SubTitle("P/S/O")
						Spacer()
						SubTitle("DT03")
						SubTitle("/")
						SubTitle("R229")
						SubTitle("/")
						SubTitle("DT09")
					}
					Grid(pluckService.pluckList!.plucks)
				}
			}
			VStack{
				PalleType(cargoCarriers: cargoCarriers)
					.environmentObject(pluckService)
				DefaultButton("Fortsett") {
					next()
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding(.init(top: 0, leading: 10, bottom: 10, trailing: 10))
		.background(Color.backgroundColor)
	}
}

struct Grid: View {
	
	let HEADERS = ["Lok", "Vare", "Antall", "Vekt", "Vol"]
	
	var plucks: [Pluck]
	
	var numberOfProducts: Int
	var totalPackages: Int
	var totalWeight: Float
	var totalVolume: Float
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
				// Headers
				ForEach(HEADERS, id: \.self) { header in
					Paragraph(header)
				}
				
				ForEach(plucks) { pluck in
					Paragraph(pluck.product.location.name)
					Paragraph(pluck.product.name)
						.lineLimit(1)
						.truncationMode(.tail)
					Paragraph(String(pluck.amount))
					Paragraph(String(Float(pluck.amount) * pluck.product.weight))
					Paragraph(String(Float(pluck.amount) * pluck.product.volume))
				}
				
				// Bottom line
				Paragraph("Sum")
				Paragraph(String(numberOfProducts))
				Paragraph(String(totalPackages))
				Paragraph(String(totalWeight))
				Paragraph(String(totalVolume))
			}
		}
	}
	
	init (_ plucks: [Pluck]) {
		self.plucks = plucks
		
		self.numberOfProducts = plucks.count
		
		self.totalPackages = plucks.map { pluck in
			return pluck.amount
		}.reduce(0) { (result, element) -> Int in
			return result + element
		}
		
		self.totalWeight = plucks.map { pluck in
			return Float(pluck.amount) * pluck.product.weight
		}.reduce(0) { (result, element) -> Float in
			return result + element
		}
		
		self.totalVolume = plucks.map { pluck in
			return Float(pluck.amount) * pluck.product.volume
		}.reduce(0) { (result, element) -> Float in
			return result + element
		}
	}
}

struct PluckInfo_Previews: PreviewProvider {
	static var previews: some View {
			PluckInfo(cargoCarriers: [], next: {
				print("next page")
			})
		.environmentObject(PluckPageService())
	}
}
