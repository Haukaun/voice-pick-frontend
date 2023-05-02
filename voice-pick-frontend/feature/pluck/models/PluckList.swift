//
//  PluckList.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 17/02/2023.
//
import Foundation

struct PluckList: Codable, Equatable {
	let id: Int
	let route: String
	let destination: String
	var confirmedAt: Date?
	var finishedAt: Date?
	let user: User
	var plucks: [Pluck]
	var cargoCarrier: CargoCarrier?
	let location: PluckListLocation
	
	static func == (lhs: PluckList, rhs: PluckList) -> Bool {
		return lhs.id == rhs.id && lhs.route == rhs.route && lhs.destination == rhs.destination && lhs.confirmedAt == rhs.confirmedAt && lhs.finishedAt == rhs.finishedAt
	}
}
