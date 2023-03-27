//
//  Location.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 02/03/2023.
//

struct Location: Codable, Hashable {
    let id: Int
    let code: String
    let controlDigits: Int
}
