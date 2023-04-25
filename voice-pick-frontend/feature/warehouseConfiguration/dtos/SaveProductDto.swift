//
//  AddProductDto.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 11/04/2023.
//

import Foundation

//Dto for add and update
struct SaveProductDto: Codable, Hashable {
	let name: String
	let weight: Double
	let volume: Double
	let quantity: Int
	let type: ProductType
	let status: ProductStatus?
	let locationCode: String?
}
