//
//  PluckInfo.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 16/02/2023.
//

import SwiftUI

struct PluckInfo: View {

    @State var pluckList: PluckList
    let next: () -> Void
    
    var body: some View {
        VStack() {
            Card {
                VStack(spacing: 24) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            DefaultLabel("Rute")
                            Title(pluckList.route)
                            Title(pluckList.destination)
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
                    Grid(pluckList.plucks)
                }
            }
            DefaultButton("Fortsett") {
                next()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(10)
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
                    Paragraph(pluck.product.location.location)
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
        PluckInfo(pluckList: .init(
            id: 1,
            route: "1351",
            destination: "Joker Åheim",
                        plucks: [
                            .init(
                                id: 0,
                                product:
                                        .init(
                                            id: 0,
                                            name: "6-pack Coca Cola",
                                            location: .init(id: 0, location: "HB-209", controlDigit: "123"),
                                            weight: 9,
                                            volume: 9,
                                            quantity: 20,
                                            type: .D_PACK,
                                            status: .READY),
                                amount: 2,
                                createdAt: "02-03-2023",
                                pluckedAt: nil),
                            .init(
                                id: 1,
                                product:
                                        .init(
                                            id: 1,
                                            name: "Kiwi Bæreposer",
                                            location: .init(id: 1, location: "I-207", controlDigit: "123"),
                                            weight: 15,
                                            volume: 5,
                                            quantity: 50,
                                            type: .D_PACK,
                                            status: .READY),
                                amount: 8,
                                createdAt: "02-03-2023",
                                pluckedAt: nil),
                            .init(
                                id: 2,
                                product: .init(
                                    id: 2,
                                    name: "Idun Hambuger Dressing",
                                    location: .init(id: 2, location: "O-456", controlDigit: "314"),
                                    weight: 1,
                                    volume: 1,
                                    quantity: 145,
                                    type: .F_PACK,
                                    status: .READY),
                                amount: 12,
                                createdAt: "02-03-2023",
                                pluckedAt: nil)
                        ]), next: {
                            print("Next page")
                        })
    }
}
