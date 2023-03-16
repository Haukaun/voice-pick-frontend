//
//  LoginResponse.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 16/03/2023.
//

import Foundation

struct LoginResponse: Codable {
	let access_token: String
	let refresh_token: String
	let expires_in: String
	let refresh_expires_in: String
	let token_type: String
}
