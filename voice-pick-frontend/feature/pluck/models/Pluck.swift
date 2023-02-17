//
//  Pluck.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 17/02/2023.
//

enum PluckType {
    case D_PACK
    case F_PACK
}

enum PluckStatus {
    case READY
    case EMPTY
}

struct Pluck {
    let id: Int
    let productName: String
    let location: String
    let quantity: Int
    let type: PluckType
    let status: PluckStatus
    let weight: Float
}
