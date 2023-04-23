//
//  UpdatePluckRequest.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 22/04/2023.
//

import Foundation

struct UpdatePluckRequest: Codable {
    let amountPlucked: Int
    let confirmedAt: String?
    let pluckedAt: String?
}
