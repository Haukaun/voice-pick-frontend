//
//  LocationType.swift
//  voice-pick-frontend
//
//  Created by tama on 22/04/2023.
//

import SwiftUI

struct LocationType: View {
	var locationTypes = ["PRODUCT", "PLUCK_LIST"]
	
	@EnvironmentObject private var pluckService: PluckService
	@Binding var selectedLocationType: String
	
	var body: some View {
		VStack {
			CustomDisclosureGroup(
				title: "Valgt type:",
				value: selectedLocationType,
				list: locationTypes
			) { selectedLocationType in
				self.selectedLocationType = selectedLocationType
			}
		}
		.background(Color.backgroundColor)
		.cornerRadius(5)
		
	}
	
	/**
	 Set the string to the selected button
	 */
	private func onSelectedString(_ locationType: String){
		selectedLocationType = locationType
	}
}

struct LocationType_Previews: PreviewProvider {
	static var previews: some View {
		LocationType(locationTypes: ["PRODUCT", "PLUCK_LIST"], selectedLocationType: .constant(""))
			.environmentObject(PluckService())
	}
}
