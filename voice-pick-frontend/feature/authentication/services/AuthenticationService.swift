//
//  AuthenticationService.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 16/03/2023.
//

import Foundation
import KeychainSwift
import OSLog

class AuthenticationService: ObservableObject {
    let keychain = KeychainSwift()
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let requestService = RequestService()
    
    private let voiceLog = VoiceLog.shared
    
    private var storedRoles: [RoleDto]? {
        get {
            guard let data = keychain.getData("roles"), let roles = try? JSONDecoder().decode([RoleDto].self, from: data) else {
                return []
            }
            return roles
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                keychain.set(data, forKey: "roles")
            } else {
                keychain.delete("roles")
            }
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
    
    @Published var roles: [RoleDto]? = nil {
        didSet {
            storedRoles = roles
        }
    }
    
    @Published var uuid: String = "" {
        didSet {
            storedUuid = uuid
        }
    }
    
    @Published var userName: String = "" {
        didSet {
            storedUserName = userName
        }
    }
    
    @Published var email: String = "" {
        didSet {
            storedEmail = email
        }
    }
    
    @Published var emailVerified: Bool = false {
        didSet {
            storedEmailVerified = emailVerified
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
            storedWarehouseAddress = warehouseAddress
        }
    }
    
    init() {
        self.roles = storedRoles
        self.uuid = storedUuid
        self.userName = storedUserName
        self.email = storedEmail
        self.emailVerified = storedEmailVerified
        
        self.accessToken = storedAccessToken
        self.refreshToken = storedRefreshToken
        
        self.warehouseId = storedWarehouseId
        self.warehouseName = storedWarehouseName
        self.warehouseAddress = storedWarehouseAddress
    }
    
    /**
     Logs out the user from the application
     */
    func logout() {
        requestService.post(
            path: "/auth/signout",
            token: self.accessToken,
            body: TokenDto(token: self.refreshToken),
            responseType: String.self,
            completion: { result in
                switch result {
                case .failure(let error as RequestError):
                    if (error.errorCode == 401) {
                        self.clear()
                    }
                case .success(_):
                    self.clear()
                case .failure(let error):
                    os_log("Failed to sign out: \(error)")
                }
            })
    }
    
    func clearWarehouse() {
        DispatchQueue.main.async {
            self.warehouseId = nil
            self.warehouseName = ""
            self.warehouseAddress = ""
        }
    }
	
	func userHasRole(_ type: RoleType) -> Bool {
		return self.roles?.first(where: { $0.type == type }) != nil
	}
    
    private func clear() {
        DispatchQueue.main.async {
            self.roles = nil
            self.uuid = ""
            self.userName = ""
            self.email = ""
            self.emailVerified = false
            
            self.accessToken = ""
            self.refreshToken = ""
            
            self.warehouseId = nil
            self.warehouseName = ""
            self.warehouseAddress = ""
            
            self.voiceLog.clearMessages()
        }
    }
}
