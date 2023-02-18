//
//  Product.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 17/02/2023.
//

enum ProductType {
    case D_PACK
    case F_PACK
}

enum ProductStatus {
    case READY
    case EMPTY
}

struct Product: Hashable {
    let id: Int
    let name: String
    let location: String
    let weight: Float // weight of one product
    let volume: Float // volume of one product
    let quantity: Int // numbers of product in stock
    let type: ProductType
    let status: ProductStatus
    
    func has(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.location == rhs.location && lhs.weight == rhs.weight && lhs.weight == rhs.weight && lhs.volume == rhs.volume && lhs.quantity == rhs.quantity && lhs.type == rhs.type && lhs.status == rhs.status
    }
}
