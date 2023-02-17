import SwiftUI
struct PalleType: View {
    @State var palle = "Trepalle"

    var body: some View {
        VStack {
            DisclosureGroup("Valgt pall-type: \(palle)") {
                HStack {
                    pallButton(title: "Trepalle", action: { palle = "Trepalle" })
                    Spacer()
                    pallButton(title: "Liten", action: { palle = "Liten" })
                    Spacer()
                    pallButton(title: "Stor", action: { palle = "Stor" })
                }.padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
            }
            .accentColor(.mountain)
            .padding(15)
        }
        .background(Color.snow)
        .cornerRadius(5)
    }

    func pallButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Spacer()
            Text(title)
                .padding(15)
                .fontWeight(.bold)
                .font(.button)
                .foregroundColor(.snow)
            Spacer()
        }
        .background(Color.night)
        .cornerRadius(5)
    }
}

struct PalleType_Previews: PreviewProvider {
    static var previews: some View {
        PalleType()
    }
}
