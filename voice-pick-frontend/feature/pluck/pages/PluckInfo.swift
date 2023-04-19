//
//  PluckInfo.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 16/02/2023.
//

import SwiftUI

struct PluckInfo: View {
	
	let requestService = RequestService()
	@State var showAlert = false;
	@State var errorMessage = "";
	
	@EnvironmentObject var pluckService: PluckService
	
	/*
	 Error handling for cargo carriers
	 */
	func handleError(errorCode: Int) {
		switch errorCode {
		case 404:
			showAlert = true;
			errorMessage = "Ingen lastebærere ble funnet. Lukk appen og rapporter dette problemet."
			break
		default:
			showAlert = true;
			errorMessage = "Noe gikk galt. Vennligst lukk applikasjonen og prøv på nytt, eller rapporter feilen."
			break
		}
	}
	
	
	var body: some View {
		VStack() {
			Card {
				VStack(spacing: 24) {
					HStack(alignment: .top) {
						VStack(alignment: .leading) {
							DefaultLabel("Rute")
							Title(pluckService.pluckList?.route ?? "")
							Title(pluckService.pluckList?.destination ?? "")
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
				CargoType(cargoCarriers: pluckService.cargoCarriers)
				DefaultButton("Fortsett") {
					pluckService.doAction(keyword: "next", fromVoice: false)
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding(5)
		.background(Color.backgroundColor)
		.onAppear{
			requestService.get(path: "/cargo-carriers", responseType: [CargoCarrier].self, completion: {result in
				switch result {
				case .success(let cargoCarriers):
					pluckService.setCargoCarriers(cargoCarriers)
					break
				case .failure(let error as RequestError):
					handleError(errorCode: error.errorCode)
					break
				default:
					break
				}
			})
		}
		.alert("Palle", isPresented: $showAlert, actions: {}, message: {Text(errorMessage)})
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
					Paragraph(pluck.product.location.code)
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
	static func initPluckService() -> PluckService {
		let pluckService = PluckService()
		
		pluckService.setPluckList(.init(
			id: 0,
			route: "234",
			destination: "Kiwi Nedre Strandgate 2",
			user: User(uuid: "1", firstName: "Ola", lastName: "Nordmann", email: "olanordmann@icloud.com"),
			plucks: [],
			location: .init(
				code: "P345",
				controlDigits: 123, locationType: "PLUCK_LIST")))
		
		return pluckService
	}
	
	static var previews: some View {
		PluckInfo()
			.environmentObject(initPluckService())
			.environmentObject(PluckService())
	}
}
