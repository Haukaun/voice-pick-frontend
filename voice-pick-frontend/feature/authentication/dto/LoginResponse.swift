//
//  LoginResponse.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 16/03/2023.
//

import Foundation

struct LoginResponse: Codable {
	let accessToken: String
	let refreshToken: String
	let expiresIn: String
	let refreshExpiresIn: String
	let tokenType: String
	let uuid: String
	let username: String
	let email: String
	let emailVerified: Bool
	let roles: [RoleDto]
	let warehouse: WarehouseDto?
}
