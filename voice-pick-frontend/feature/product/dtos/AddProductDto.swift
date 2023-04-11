//
//  AddProductDto.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 11/04/2023.
//

import Foundation

struct AddProductDto: Codable {
	let name: String
	let location: String
	let weight: Double
	let volume: Double
	let quantity: Int
	let type: ProductType
}
