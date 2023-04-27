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
	let encoder = JSONEncoder()
	let decoder = JSONDecoder()
	
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
    
    private var storedUuid: String {
        get {
            return keychain.get("uuid") ?? ""
        }
        set {
            keychain.set(newValue, forKey: "uuid")
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }

	private var storedWarehouseId: Int? {
		get {
			return Int(keychain.get("warehouseId") ?? "")
		}
		set {
			if let newValue = newValue {
				keychain.set("\(newValue)", forKey: "warehouseId")
				DispatchQueue.main.async {
					self.objectWillChange.send()
				}
			}
		}
	}
	
	private var storedWarehouseName: String {
		get {
			return keychain.get("warehouseName") ?? ""
		}
		set {
			keychain.set(newValue, forKey: "warehouseName")
		}
	}
	
	private var storedWarehouseAddress: String {
		get {
			return keychain.get("warehouseAddress") ?? ""
		}
		set {
			keychain.set(newValue, forKey: "warehouseAddress")
		}
	}
	
	@Published var warehouseId: Int? = nil {
		didSet {
			storedWarehouseId = warehouseId
		}
	}
	
	@Published var warehouseName: String = "" {
		didSet {
			storedWarehouseName = warehouseName
		}
	}
	
	@Published var warehouseAddress: String = "" {
		didSet {
			storedWarehouseName = warehouseName
		}
	}
	
	
	private var storedUserName: String {
		get {
			return keychain.get("name") ?? ""
		}
		set {
			keychain.set(newValue, forKey: "name")
			DispatchQueue.main.async {
				self.objectWillChange.send()
			}
		}
	}
	
	@Published var userName: String = "" {
		didSet {
			storedUserName = userName
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
    
    @Published var uuid: String = "" {
        didSet {
            storedUuid = uuid
        }
    }
	
	init() {
        self.uuid = uuid
		self.userName = storedUserName
		self.accessToken = storedAccessToken
		self.refreshToken = storedRefreshToken
		self.emailVerified = storedEmailVerified
		self.email = storedEmail
		self.warehouseId = storedWarehouseId
		self.warehouseName = storedWarehouseName
		self.warehouseAddress = warehouseAddress
	}
    
    func clear() {
        DispatchQueue.main.async {
            self.uuid = ""
            self.userName = ""
            self.accessToken = ""
            self.refreshToken = ""
            self.emailVerified = false
            self.email = ""
            self.warehouseId = nil
            self.warehouseName = ""
            self.warehouseAddress = ""
        }
    }
}
