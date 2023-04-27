//
//  ChangePasswordRequest.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 26/04/2023.
//

import Foundation

struct ChangePasswordRequest: Codable {
    let email: String
    let currentPassword: String
    let newPassword: String
}
