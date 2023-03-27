//
//  PluckList.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 17/02/2023.
//

struct PluckList: Codable {
	let id: Int
	let route: String
	let destination: String
	var confirmedAt: String?
	var finishedAt: String?
	var plucks: [Pluck]
	let location: Location
	var cargoCarrier: CargoCarrier?
	// TODO: Add user field when back-end is complete
	// let user: User
}
