//
//  LocationPluckListResponse.swift
//  voice-pick-frontend
//
//  Created by tama on 02/05/2023.
//

import Foundation

struct LocationPluckListResponse: Hashable, Codable, Equatable {
    let id: Int
    let route: String
    let destination: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: LocationPluckListResponse, rhs: LocationPluckListResponse) -> Bool {
        return lhs.id == rhs.id && lhs.destination == rhs.destination && lhs.route == rhs.route
    }
}
