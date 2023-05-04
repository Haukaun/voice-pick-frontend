//
//  RoleDto.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 02/05/2023.
//

import Foundation

struct RoleDto : Codable, Hashable, Identifiable {
	let id: Int
	let type: RoleType
}

enum RoleType: String, Codable, CaseIterable {
	case USER
	case LEADER
}
