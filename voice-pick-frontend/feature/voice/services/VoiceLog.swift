//
//  VoiceChatService.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 28/04/2023.
//

import Foundation

class VoiceLog: ObservableObject {
    
    // Singleton
    static let shared = VoiceLog()
    
    @Published var logMessages: [LogMessage] = []
    
    /**
     Adds a message to the log
     
     - Parameters:
     - chatMessage: The message to be added
     */
    func addMessage(_ logMessage: LogMessage) {
        guard logMessage.message.count > 0 else { return }
        
        DispatchQueue.main.async {
            if self.logMessages.count > 100 {
                self.logMessages.removeFirst()
            }
            self.logMessages.append(logMessage)
        }
    }
    
    /**
     Removes all messages from the log
     */
    func clearMessages() {
        DispatchQueue.main.async {
            self.logMessages.removeAll()
        }
    }
}

