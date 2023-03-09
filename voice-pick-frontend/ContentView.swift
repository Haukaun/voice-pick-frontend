//
//  ContentView.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 10/02/2023.
//

import SwiftUI
import Speech

struct ContentView: View {
	
	
	func tempString(change: String){
		print(change)
	}

	var body: some View {
		VoiceView(onChange: tempString){
			PluckPage()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

