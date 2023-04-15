//
//  Location.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 02/03/2023.
//

struct Location: Codable, Hashable {
	let code: String
	let controlDigits: Int
	let locationType: String
}
