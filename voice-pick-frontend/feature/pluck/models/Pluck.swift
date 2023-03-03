//
//  Pluck.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 17/02/2023.
//

import Foundation

struct Pluck: Hashable, Identifiable, Codable {
    let id: Int
    let product: Product
    let amount: Int // how many should be picked
    let createdAt: String
    let pluckedAt: String?
    
    func has(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Pluck, rhs: Pluck) -> Bool {
        return lhs.id == rhs.id && lhs.product == rhs.product && lhs.amount == rhs.amount
    }
}
