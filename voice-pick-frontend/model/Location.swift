//
//  Location.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 02/03/2023.
//
import Foundation

enum LocationType: String, Codable, CaseIterable {
		case PRODUCT = "PRODUCT"
		case PLUCK_LIST = "PLUCK_LIST"
}

struct Location: Codable, Hashable, Identifiable {
	var id = UUID()
	var code: String
	let controlDigits: Int
	let locationType: String
	
	private enum CodingKeys: String, CodingKey {
		case code, controlDigits, locationType
	}
}
