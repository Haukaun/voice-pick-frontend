//
//  ContentView.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 10/02/2023.
//

import SwiftUI
import Speech

struct ContentView: View {
	
    var body: some View {
			PluckListDisplay([
				.init(
					id: 0,
					product:
							.init(
								id: 0,
								name: "6-pack Coca Cola",
								location: .init(id: 0, location: "HB-209", controlDigit: 123),
								weight: 100.0,
								volume: 9,
								quantity: 20,
								type: .D_PACK,
								status: .READY),
					amount: 2,
					createdAt: "02-03-2023",
					pluckedAt: nil,
                    show: true),
				.init(
					id: 1,
					product:
							.init(
								id: 1,
								name: "Kiwi Bæreposer",
								location: .init(id: 1, location: "I-207", controlDigit: 222),
								weight: 100.0,
								volume: 5,
								quantity: 50,
								type: .D_PACK,
								status: .READY),
					amount: 8,
					createdAt: "02-03-2023",
					pluckedAt: nil,
                    show: true),
				.init(
					id: 2,
					product: .init(
						id: 2,
						name: "Idun Hambuger Dressing",
						location: .init(id: 2, location: "O-456", controlDigit: 333),
						weight: 50.0,
						volume: 1,
						quantity: 145,
						type: .F_PACK,
						status: .READY),
					amount: 12,
					createdAt: "02-03-2023",
					pluckedAt: nil,
                    show: true)
			], next: { print("next") })
    }
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

