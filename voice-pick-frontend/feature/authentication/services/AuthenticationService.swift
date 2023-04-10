//
//  AuthenticationService.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 16/03/2023.
//

import Foundation
import KeychainSwift

class AuthenticationService: ObservableObject {
	let keychain = KeychainSwift()
	
	private var storedAccessToken: String {
		get {
			return keychain.get("accessToken") ?? ""
		}
		set {
			keychain.set(newValue, forKey: "accessToken")
			DispatchQueue.main.async {
				self.objectWillChange.send()
			}
		}
	}
	
	private var storedRefreshToken: String {
		get {
			return keychain.get("refreshToken") ?? ""
		}
		set {
			keychain.set(newValue, forKey: "refreshToken")
			DispatchQueue.main.async {
				self.objectWillChange.send()
			}
		}
	}
	
	private var storedEmailVerified: Bool {
		get {
			return keychain.getBool("emailVerified") ?? false
		}
		set {
			keychain.set(newValue, forKey: "emailVerified")
			DispatchQueue.main.async {
				self.objectWillChange.send()
			}
		}
	}
	
	private var storedEmail: String {
		get {
			return keychain.get("email") ?? ""
		}
		set {
			keychain.set(newValue, forKey: "email")
			DispatchQueue.main.async {
				self.objectWillChange.send()
			}
		}
	}
	
	@Published var accessToken: String = "" {
		didSet {
			storedAccessToken = accessToken
		}
	}
	
	@Published var refreshToken: String = "" {
		didSet {
			storedRefreshToken = refreshToken
		}
	}
	
	@Published var emailVerified: Bool = false {
		didSet {
			storedEmailVerified = emailVerified
		}
	}
	
	@Published var email: String = "" {
		didSet {
			storedEmail = email
		}
	}
	
	init() {
		self.accessToken = storedAccessToken
		self.refreshToken = storedRefreshToken
		self.emailVerified = storedEmailVerified
		self.email = storedEmail
	}
}
