//
//  PluckListLocation.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 22/03/2023.
//

import Foundation

struct PluckListLocation: Codable, Hashable {
	let id: Int
	let code: String
	let controlDigits: Int
}
