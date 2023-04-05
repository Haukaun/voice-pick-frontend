//
//  User.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 24/03/2023.
//

import Foundation


struct User : Codable {
	let id: String
	let firstName: String
	let lastName: String
	let email: String
}
