//
//  AuthenticationService.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 16/03/2023.
//

import Foundation
import KeychainSwift

class AuthenticationService: ObservableObject {
	
	private let keychain = KeychainSwift()
	@Published var authToken: LoginResponse?
	@Published var isEmailVerified: Bool?
	@Published var userEmail: String?
	
	func saveToken(token: LoginResponse) {
		if let data = try? JSONEncoder().encode(token) {
			keychain.set(data, forKey: "authToken")
			if let data = keychain.getData("authToken") {
				DispatchQueue.main.async { [weak self] in
					self?.authToken = try? JSONDecoder().decode(LoginResponse.self, from: data)
				}
			}
		}
	}
	
	func deleteToken() {
		keychain.delete("authToken")
		DispatchQueue.main.async { [weak self] in
			self?.authToken = nil
		}
	}
	
}
