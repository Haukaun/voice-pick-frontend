//
//  PluckComplete.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 01/03/2023.
//

import SwiftUI

struct PluckComplete: View {
	
	let ICON_SIZE = CGFloat(100)
	
	@State private var timeRemaining = 2
	let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect();
	
	@EnvironmentObject var pluckService: PluckService
	
	var body: some View {
		VStack {
			Image(systemName: "checkmark.seal.fill")
				.resizable()
				.scaledToFit()
				.frame(width: ICON_SIZE, height: ICON_SIZE)
			Text("Ferdig med alle plukk")
				.font(Font.header1)
		}
		.onReceive(timer) { time in
			if timeRemaining > 0 {
				timeRemaining -= 1
			} else {
				pluckService.doAction(keyword: "complete", fromVoice: false)
			}
		}
		.foregroundColor(.snow)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.success)
	}
}

struct PluckComplete_Previews: PreviewProvider {
	static var previews: some View {
		PluckComplete()
	}
}
