import SwiftUI
struct CargoType: View {
	var cargoCarriers: [CargoCarrier]
	
	@EnvironmentObject private var pluckService: PluckService
	
	var body: some View {
			CustomDisclosureGroup(
				title: "Valgt palletype:",
				selectedValue: pluckService.pluckList?.cargoCarrier?.name ?? "Ingen valgt",
				list: cargoCarriers.map { $0.name }
			) { selectedCargoCarrierName in
				if let selectedCargoCarrier = cargoCarriers.first(where: { $0.name == selectedCargoCarrierName }) {
					onSelectedString(selectedCargoCarrier)
				}
			}
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
