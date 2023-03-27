import SwiftUI
struct PalleType: View {
	var cargoCarriers: [CargoCarrier]
	
	@EnvironmentObject private var pluckService: PluckService
	
	var body: some View {
		VStack {
			DisclosureGroup(content: {
				ScrollView {
					VStack {
						ForEach(cargoCarriers, id: \.id) { cargoCarrier in
							cargoButton(title: cargoCarrier.name, action: { onSelectedString(cargoCarrier) })
						}
					}.padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
				}
			}, label: {
				HStack {
					Text("Valgt palletype:")
					Text(pluckService.pluckList?.cargoCarrier?.name ?? "Not selected")
						.bold()
						.foregroundColor(.traceLightYellow)
				}
			})
			.accentColor(.mountain)
			.padding(15)
		}
		.background(Color.componentColor)
		.cornerRadius(5)
		
	}
	
	/**
	 Set the string to the selected button
	 */
	private func onSelectedString(_ cargoCarrier: CargoCarrier){
		pluckService.doAction(keyword: cargoCarrier.phoneticIdentifier, fromVoice: false)
	}
	
	/**
	 Button for displaying the cargo
	 */
	func cargoButton(title: String, action: @escaping () -> Void) -> some View {
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
		.cornerRadius(UIView.standardCornerRadius)
	}
}

struct PalleType_Previews: PreviewProvider {
	static var previews: some View {
		PalleType(cargoCarriers: [])
	}
}
