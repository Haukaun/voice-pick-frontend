//
//  ProductCard.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/02/2023.
//

import SwiftUI



struct PluckCard: View {
    
    @State private var isAnswerSelected = false
    
    let id: Int
    let name: String
    let location: Location
    let amount: Int
    let weight: Float
    let type: ProductType
    let status: ProductStatus
    let onComplete: (Int) -> Void
    let showControlDigits: Bool
    
    init(id: Int, name: String, location: Location, amount: Int, weight: Float, type: ProductType, status: ProductStatus, onComplete: @escaping (Int) -> Void, showControlDigits: Bool) {
        self.isAnswerSelected = false
        self.id = id
        self.name = name
        self.location = location
        self.amount = amount
        self.weight = weight
        self.type = type
        self.status = status
        self.onComplete = onComplete
        self.showControlDigits = showControlDigits
    }
    
    private func getTotalWeight() -> Float {
        return weight * Float(amount)
    }
    
    var body: some View {
        Card() {
            VStack(alignment: .leading) {
                VStack(alignment: .leading){
                    Paragraph("Vare")
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Paragraph("\(name)")
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
                        Paragraph("\(location.location)")
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .bold()
                    }
                    VStack (alignment: .leading){
                        Paragraph("Antall")
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Paragraph("\(amount)")
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
                        Paragraph("\(type)")
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
                if(!isAnswerSelected && showControlDigits){
                    Group{
                        Divider()
                            .padding(.bottom)
                        Paragraph("Velg kontrollsiffer")
                            .bold()
                        HStack (spacing: 10){
                            ButtonRandomizer(correctAnswer: location.controlDigit) { number in
                                isAnswerSelected = true
                            }
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                }
            }
            
        }
        .swipeActions(edge: .trailing, content:{
            isAnswerSelected ?
            Button(role: .destructive) {
                onComplete(id)
            } label: {
                Label("Svipe venstre for å fullføre" , systemImage: "checkmark.circle.fill")
            }.tint(.success)
            :
            Button(role: .none) {
                print(isAnswerSelected)
            } label: {
                Label("Velg siffer først" , systemImage: "xmark.app.fill")
            }.tint(.none)
            
        })
        
    }
}

struct PluckCard_Previews: PreviewProvider {
    static var previews: some View {
        PluckCard(
            id: 1,
            name: "Cola",
            location: Location.init(id: 1, location: "L-342", controlDigit: 124),
            amount: 34,
            weight: 45,
            type: ProductType.F_PACK,
            status: ProductStatus.READY,
            onComplete: { id in
                print(id)
            },
            showControlDigits: true
        )
    }
}
