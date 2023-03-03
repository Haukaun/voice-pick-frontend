//
//  PluckList.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 17/02/2023.
//

struct PluckList: Codable {
    let id: Int
    let route: String
    let destination: String
    var plucks: [Pluck]
}
