//
//  UpdatePluckListRequest.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 22/04/2023.
//

import Foundation

struct UpdatePluckListRequest: Codable {
    let confirmedAt: String?
    let finishedAt: String?
}
