//
//  CargoCarrier.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/03/2023.
//

import Foundation


struct CargoCarrier: Hashable, Identifiable, Codable {
	let id: Int
	var name: String
	let identifier: Int
	let phoneticIdentifier: String
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	static func == (lhs: CargoCarrier, rhs: CargoCarrier) -> Bool {
		return lhs.id == rhs.id && lhs.name == rhs.name && lhs.identifier == rhs.identifier
	}
}
