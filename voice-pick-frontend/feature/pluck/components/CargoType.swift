import SwiftUI
struct CargoType: View {
	var cargoCarriers: [CargoCarrier]
	
	@State private var isColorEnabled: Bool = true
	
	@EnvironmentObject private var pluckService: PluckService
	
	var body: some View {
		CustomDisclosureGroup(
			title: "Valgt palletype:",
			selectedValue: pluckService.pluckList?.cargoCarrier?.name ?? "Ingen valgt",
			list: cargoCarriers.map { $0.name },
			action: { selectedCargoCarrierName in
				if let selectedCargoCarrier = cargoCarriers.first(where: { $0.name == selectedCargoCarrierName }) {
					onSelectedString(selectedCargoCarrier)
				}
			},
			isColorEnabled: $isColorEnabled)
	}
	
	/**
	 Set the string to the selected button
	 */
	private func onSelectedString(_ cargoCarrier: CargoCarrier){
		pluckService.doAction(keyword: cargoCarrier.phoneticIdentifier, fromVoice: false)
	}
}

struct PalleType_Previews: PreviewProvider {
	static var previews: some View {
		CargoType(cargoCarriers: [])
			.environmentObject(PluckService())
	}
}
