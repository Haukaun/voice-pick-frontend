//
//  PalletInfoDto.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 11/04/2023.
//

import Foundation

struct PalletInfoDto: Codable {
	let productName: String
	let productWeight: Double
	let productVolume: Double
	let quantity: Int
	let type: ProductType
}
