//
//  ProductCard.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/02/2023.
//

import SwiftUI



struct PluckCard: View, Hashable {
    
    let id: Int
    let name: String
    let location: String
    let amount: Int
    let weight: Float
    let type: ProductType
    let status: ProductStatus
    
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
                        Paragraph("\(location)")
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
                        Paragraph("\(weight)")
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
            }
        }
        .transition(.slide)
    }
}

struct PluckCard_Previews: PreviewProvider {
    static var previews: some View {
        PluckCard(id: 1,name: "Cola", location: "H-23", amount: 34, weight: 45, type: ProductType.F_PACK, status: ProductStatus.READY)
    }
}
