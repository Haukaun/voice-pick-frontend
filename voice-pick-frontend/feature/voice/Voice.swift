//
//  Voice.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 11/04/2023.
//

import Foundation
import SwiftUI
import AVFoundation

enum Voice: String, CaseIterable, Identifiable {
case nathan = "com.apple.voice.enhanced.en-US.Nathan"
case evan = "com.apple.voice.enhanced.en-US.Evan"
	
	var id: String { self.rawValue }
	var name: String {
		switch self {
		case .nathan: return "Nathan"
		case .evan: return "Evan"
		}
	}
}


