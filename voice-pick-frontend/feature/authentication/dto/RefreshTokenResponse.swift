//
//  RefreshTokenResponse.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 04/05/2023.
//

import Foundation

struct RefreshTokenResponse : Codable {
	var access_token: String
	var refresh_token: String
	var expires_in: String
	var refresh_expires_in: String
	var token_type: String
}
