//
//  ProductDto.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 25/04/2023.
//

import Foundation


struct ProductDto: Codable, Hashable {
	let id: Int
	let name: String
	let weight: Double
	let volume: Double
	let quantity: Int
	let type: ProductType
	let status: ProductStatus
	let location: Location?
}
