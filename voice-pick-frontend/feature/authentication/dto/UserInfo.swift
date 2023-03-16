//
//  UserInfo.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 03/03/2023.
//

import Foundation

struct UserInfo : Codable {
	var firstName: String? = nil
	var lastName: String? = nil
	let email: String
	let password: String
}
