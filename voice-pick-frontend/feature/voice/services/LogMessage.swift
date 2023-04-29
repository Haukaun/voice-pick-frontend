//
//  ChatMessage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 28/04/2023.
//

import Foundation

enum LogMessageType: String, Codable, CaseIterable {
    case INPUT = "INPUT"
    case OUTPUT = "OUTPUT"
    
}

struct LogMessage: Hashable {
    let id = UUID()
    let message: String
    let type: LogMessageType
}
