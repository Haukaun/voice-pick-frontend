//
//  ProductCard.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/02/2023.
//

import SwiftUI



struct PluckCard: View {
    
    @EnvironmentObject var pluckService: PluckService
    
    @State var pluck: Pluck
    
    @State var showDetailPluck: Bool = false
    @State var showPopUp: Bool = false
    
    @State var amountField = 0
    
    private var totalWeight: Float {
        return pluck.product.weight * Float(pluck.amount)
    }
    
    /**
     Change color on Progressview widget.
     */
    private func progressColor() -> Color {
        let progress = Float(amountField) / Float(pluck.amount)
        
        switch progress {
        case 0..<0.33:
            return Color.traceLightYellow
        case 0.33..<0.66:
            return Color.traceMediYellow
        case 0.66..<0.99:
            return Color.traceDarkYellow
        case 1:
            return Color.success
        default:
            return Color.error
        }
    }
    
    private func showControlDigits() -> Bool {
        return pluckService.pluckList?.plucks.first(where: { $0.id == self.pluck.id } )?.confirmedAt == nil
    }
    
    private func disableControlDigits() -> Bool {
        return pluckService.pluckList?.plucks.first(where: { $0.pluckedAt == nil } )?.id != self.pluck.id
    }
    
    private func allowSwipe() -> Bool {
        let pluck = pluckService.pluckList?.plucks.first(where: { $0.id == self.pluck.id })
        let activePluck = pluckService.pluckList?.plucks.first(where: { $0.pluckedAt == nil } )
        
        return pluck?.confirmedAt != nil && pluck?.amountPlucked == pluck?.amount && pluck?.id == activePluck?.id
    }
    
    private func enableAmountSelect() -> Bool {
        return pluckService.pluckList?.plucks.first(where: { $0.pluckedAt == nil } )?.id == self.pluck.id && pluckService.pluckList?.plucks.first(where: { $0.id == self.pluck.id } )?.confirmedAt != nil
    }
    
    var body: some View {
        Card() {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Paragraph("Vare")
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Paragraph("\(pluck.product.name)")
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .bold()
                            .padding(.bottom)
                    }
                    Spacer()
                    Button {
                        showDetailPluck = true
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .font(Font.infoButton)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .font(Font.button)
                    .foregroundColor(.traceMediYellow)
                    .clipShape(Capsule())
                }
                HStack(spacing: 30) {
                    VStack (alignment: .leading) {
                        Paragraph("Lokasjon")
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Paragraph("\(pluck.product.location.code)")
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .bold()
                    }
                    VStack (alignment: .leading) {
                        Paragraph("Antall")
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Paragraph("\(pluck.amount)")
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .bold()
                    }
                    VStack (alignment: .leading) {
                        Paragraph("Vekt")
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Paragraph("\(totalWeight)")
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .bold()
                    }
                    VStack (alignment: .leading) {
                        Paragraph("Type")
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Paragraph("\(pluck.product.type)")
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .bold()
                    }
                    VStack(alignment: .leading) {
                        Paragraph("Status")
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Paragraph("\(pluck.product.status)")
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .bold()
                    }
                }
                ProgressView(value: Double(amountField), total: Double(pluck.amount))
                        .tint(progressColor())
                if (showControlDigits()) {
                    ButtonRandomizer(
                        correctAnswer: pluck.product.location.controlDigits,
                        onCorrectAnswerSelected: { number in
                            pluckService.doAction(keyword: "\(number)", fromVoice: false)
                        },
                        disableButtons: disableControlDigits())
                }
            }
        }
        .sheet(isPresented: $showDetailPluck) {
            PluckCardDetail(pluck: pluck)
        }
        .onTapGesture {
            if (enableAmountSelect()) {
                showPopUp = true
            }
        }
        .alert("Oppgi antall plukket", isPresented: $showPopUp, actions: {
            TextField("Antall", value: $amountField, format: .number)
                .keyboardType(.numberPad)
            Button("OK", action: {
                pluckService.doAction(keyword: String(amountField), fromVoice: false)
            })
        })
        .swipeActions(edge: .trailing, content: {
            if allowSwipe() {
                Button(role: .destructive) {
                    pluckService.doAction(keyword: "complete", fromVoice: false)
                } label: {
                    Label("Svipe venstre for å fullføre" , systemImage: "checkmark.circle.fill")
                }.tint(.success)
            } else {
                Button(role: .none) {
                } label: {
                    Label("Velg kontrollsiffer og skriv antall plukk" , systemImage: "xmark.app.fill")
                }.tint(.error)
            }
        })
    }
}

struct PluckCard_Previews: PreviewProvider {
    static var previews: some View {
        PluckCard(
            pluck: .init(
                id: 0,
                product: .init(
                    id: 0,
                    name: "Q-melk",
                    weight: 1.5,
                    volume: 1.5,
                    quantity: 100,
                    type: ProductType.D_PACK,
                    status: ProductStatus.READY,
                    location: .init(
                        code: "H209",
                        controlDigits: 432,
                        locationType: "PRODUCT")),
                amount: 10,
                amountPlucked: 0,
                createdAt: DateFormatter().string(from: Date()))
        )
    }
}
