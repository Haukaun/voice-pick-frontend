//
//  LoginResponse.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 16/03/2023.
//

import Foundation

struct LoginResponse: Codable {
	var accessToken: String
	var refreshToken: String
	var expiresIn: String
	var refreshExpiresIn: String
	var tokenType: String
	var uuid: String
	var username: String
	var email: String
	var emailVerified: Bool
	var roles: [RoleDto]
	var warehouse: WarehouseDto?
	var profilePictureName: String?
}
