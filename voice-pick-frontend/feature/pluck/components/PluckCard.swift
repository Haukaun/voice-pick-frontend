//
//  ProductCard.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/02/2023.
//

import SwiftUI



struct PluckCard: View {
	
	@State var pluck: Pluck
	
	let onSelectedControlDigit: (Int) -> Void
	let onComplete: (Int) -> Void
	let showControlDigits: Bool
	let disableControlDigits: Bool
	
	init(pluck: Pluck, onSelectedControlDigit: @escaping (Int) -> Void, onComplete: @escaping (Int) -> Void, showControlDigits: Bool, disableControlDigits: Bool) {
		self.pluck = pluck
		self.onSelectedControlDigit = onSelectedControlDigit
		self.onComplete = onComplete
		self.showControlDigits = showControlDigits
		self.disableControlDigits = disableControlDigits
	}
	
	private func getTotalWeight() -> Float {
		return pluck.product.weight * Float(pluck.amount)
	}
	
	var body: some View {
		Card() {
			VStack(alignment: .leading) {
				VStack(alignment: .leading){
					Paragraph("Vare")
						.lineLimit(1)
						.truncationMode(.tail)
					Paragraph("\(pluck.product.name)")
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
						Paragraph("\(pluck.product.location.code)")
							.lineLimit(1)
							.truncationMode(.tail)
							.bold()
					}
					VStack (alignment: .leading){
						Paragraph("Antall")
							.lineLimit(1)
							.truncationMode(.tail)
						Paragraph("\(pluck.amount)")
							.lineLimit(1)
							.truncationMode(.tail)
							.bold()
					}
					VStack (alignment: .leading){
						Paragraph("Vekt")
							.lineLimit(1)
							.truncationMode(.tail)
						Paragraph("\(getTotalWeight())")
							.lineLimit(1)
							.truncationMode(.tail)
							.bold()
					}
					VStack (alignment: .leading){
						Paragraph("Type")
							.lineLimit(1)
							.truncationMode(.tail)
						Paragraph("\(pluck.product.type)")
							.lineLimit(1)
							.truncationMode(.tail)
							.bold()
					}
					VStack(alignment: .leading){
						Paragraph("Status")
							.lineLimit(1)
							.truncationMode(.tail)
						Paragraph("\(pluck.product.status)")
							.lineLimit(1)
							.truncationMode(.tail)
							.bold()
					}
				}
				if (showControlDigits) {
					Divider()
						.padding(.bottom)
					ButtonRandomizer(
						correctAnswer: pluck.product.location.controlDigits,
						onCorrectAnswerSelected: { number in
							onSelectedControlDigit(number)
						},
						disableButtons: disableControlDigits)
				}
			}
			
		}
		.swipeActions(edge: .trailing, content:{
			!showControlDigits ?
			Button(role: .destructive) {
				onComplete(pluck.id)
			} label: {
				Label("Svipe venstre for å fullføre" , systemImage: "checkmark.circle.fill")
			}.tint(.success)
			:
			Button(role: .none) {
			} label: {
				Label("Velg siffer først" , systemImage: "xmark.app.fill")
			}.tint(.error)
			
		})
		
	}
}

struct PluckCard_Previews: PreviewProvider {
	static var previews: some View {
		PluckCard(pluck: .init(
			id: 0,
			product:
					.init(
						id: 0,
						name: "6-pack Coca Cola",
						location: .init(id: 0, code: "HB-209", controlDigits: 123),
						weight: 100.0,
						volume: 9,
						quantity: 20,
						type: .D_PACK,
						status: .READY),
			amount: 2,
			createdAt: "02-03-2023",
			confirmedAt: nil,
			pluckedAt: nil),
							onSelectedControlDigit: { number in
			print(number)
		},
							onComplete: { id in
			print(id)
		},
							showControlDigits: true,
							disableControlDigits: false
		)
	}
}
