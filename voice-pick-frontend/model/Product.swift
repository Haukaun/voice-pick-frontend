//
//  Product.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 17/02/2023.
//

enum ProductType: String, Codable, CaseIterable {
    case D_PACK = "D_PAK"
    case F_PACK = "F_PAK"
}

enum ProductStatus: String, Codable, CaseIterable {
    case READY = "READY"
    case EMPTY = "EMPTY"
    case WITHOUT_LOCATION = "WITHOUT_LOCATION"
}

struct Product: Hashable, Codable, Identifiable {
    let id: Int
    let name: String
    let weight: Float // weight of one product
    let volume: Float // volume of one product
    let quantity: Int // numbers of product in stock
    let type: ProductType
    let status: ProductStatus
		let location: Location?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.location == rhs.location && lhs.weight == rhs.weight && lhs.weight == rhs.weight && lhs.volume == rhs.volume && lhs.quantity == rhs.quantity && lhs.type == rhs.type && lhs.status == rhs.status
    }
}
