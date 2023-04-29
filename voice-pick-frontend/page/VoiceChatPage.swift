//
//  VoiceChatPage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 28/04/2023.
//

import SwiftUI

struct VoiceChatPage: View {
    
    @EnvironmentObject var authService: AuthenticationService
    @EnvironmentObject var pluckService: PluckService
    @EnvironmentObject var voiceService: VoiceService
    
    @ObservedObject var voiceLog = VoiceLog.shared
    
    var body: some View {
        VStack {
            if voiceLog.logMessages.count > 0 {
                ScrollViewReader { value in
                    ScrollView {
                        ForEach(voiceLog.logMessages, id: \.id) { logMessage in
                            HStack {
                                if logMessage.type == LogMessageType.INPUT {
                                    Spacer()
                                }
                                Text(logMessage.message)
                                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                                    .background(logMessage.type == LogMessageType.INPUT ? Color.traceLightYellow : Color.componentColor)
                                    .foregroundColor(logMessage.type == LogMessageType.INPUT ? Color.night : Color.foregroundColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                                if logMessage.type == LogMessageType.OUTPUT {
                                    Spacer()
                                }
                            }
                            .id(logMessage.id)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .onAppear {
                        value.scrollTo(voiceLog.logMessages.last?.id)
                    }
                    .onChange(of: voiceLog.logMessages.count) { _ in
                        value.scrollTo(voiceLog.logMessages.last?.id)
                    }
                }
            } else {
                VStack {
                    Text("Ingen historikk å vise")
                }
                .frame(maxHeight: .infinity)
            }
            Spacer()
            Button(action: {
                self.voiceLog.clearMessages()
            }) {
                HStack {
                    Image(systemName: "trash.fill")
                    Text("Slett samtale")
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                voiceService.startRecording()
                
                voiceService.onRecognizedTextChange = { result in
                    pluckService.doAction(
                        keyword: result,
                        fromVoice: true,
                        token: authService.accessToken
                    )
                    voiceLog.addMessage(LogMessage(message: result, type: LogMessageType.INPUT))
                }
            }
        }
        .onDisappear {
            voiceService.stopRecording()
            voiceService.onRecognizedTextChange = nil
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.backgroundColor)
    }
}

struct VoiceChatPage_Previews: PreviewProvider {
    static var previews: some View {
        VoiceChatPage()
            .environmentObject(AuthenticationService())
    }
}
