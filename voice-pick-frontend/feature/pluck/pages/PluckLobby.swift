//
//  PluckLobby.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 15/02/2023.
//

import SwiftUI
import Foundation
import SwiftClockUI

struct PluckLobby: View {
    
    @State private var date = Date()
    
    @EnvironmentObject var authenticationService: AuthenticationService
    @EnvironmentObject private var pluckService: PluckService
    
    @State var showAlert = false
    @State var errorMessage = ""
    
    var token: String?
    
    /**
     timeformat to utc time.
     */
    var timeFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
    
    /**
     format date string
     */
    func timeString(date: Date) -> String {
        let time = timeFormat.string(from: date)
        return time
    }
    
    /**
     Updates the timer to work realtime
     */
    var updateTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.date = Date()
        })
    }
    
    /**
     Greets based on date time
     */
    func greeting() -> String {
        var greet = ""
        
        let midNight0 = Calendar.current.date(bySettingHour: 0, minute: 00, second: 00, of: date)!
        let nightEnd = Calendar.current.date(bySettingHour: 3, minute: 59, second: 59, of: date)!
        let morningStart = Calendar.current.date(bySettingHour: 4, minute: 00, second: 0, of: date)!
        let morningEnd = Calendar.current.date(bySettingHour: 11, minute: 59, second: 59, of: date)!
        let noonStart = Calendar.current.date(bySettingHour: 12, minute: 00, second: 00, of: date)!
        let noonEnd = Calendar.current.date(bySettingHour: 16, minute: 59, second: 59, of: date)!
        let eveStart = Calendar.current.date(bySettingHour: 17, minute: 00, second: 00, of: date)!
        let eveEnd = Calendar.current.date(bySettingHour: 20, minute: 59, second: 59, of: date)!
        let nightStart = Calendar.current.date(bySettingHour: 21, minute: 00, second: 00, of: date)!
        let midNight24 = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
        
        if ((date >= midNight0) && (nightEnd >= date)) {
            greet = "God natt"
        } else if ((date >= morningStart) && (morningEnd >= date)) {
            greet = "God morgen"
        } else if ((date >= noonStart) && (noonEnd >= date)) {
            greet = "God ettermiddag"
        } else if ((date >= eveStart) && (eveEnd >= date)) {
            greet = "God kveld"
        } else if ((date >= nightStart) && (midNight24 >= date)) {
            greet = "God natt"
        }
        
        return greet
    }
    
    var body: some View {
        ZStack {
            VStack {
                Card {
                    HStack(alignment: .center) {
                        Spacer()
                        VStack (spacing: 30){
                            VStack(spacing: 0) {
                                Title("Velkommen!")
                                Paragraph(authenticationService.userName)
                            }
                            .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
                            VStack(spacing: 0) {
                                SubTitle(authenticationService.warehouseName)
                                DefaultLabel(authenticationService.warehouseAddress)
                            }
                            Spacer()
                            ClockView()
                                .environment(\.clockDate, $date)
                                .environment(\.clockStyle, .classic)
                                .environment(\.clockIndicatorsColor, .foregroundColor)
                                .environment(\.clockBorderColor, .traceLightYellow)
                                .frame(height: 150)
                            Divider()
                                .background(Color.foregroundColor)
                                .frame(height: 30)
                            
                            VStack(spacing: 0) {
                                Title("\(timeString(date: date))")
                                    .onAppear(perform: {let _ = self.updateTimer})
                                DefaultLabel(greeting())
                            }
                        }
                        .foregroundColor(.foregroundColor)
                        Spacer()
                    }
                    Spacer()
                }
                DefaultButton("Start plukk") {
                    pluckService.doAction(keyword: "start", fromVoice: false, token: token)
                }
                .disabled(pluckService.isLoading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
            if pluckService.isLoading {
                CustomProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(UIView.defaultPadding)
        .background(Color.backgroundColor)
        .alert("Error", isPresented: $showAlert, actions: {}, message: { Text(errorMessage) } )
        .onReceive(pluckService.$showAlert) { showAlert in
            self.showAlert = showAlert
        }
        .onReceive(pluckService.$errorMessage) { errorMsg in
            self.errorMessage = errorMsg
        }
    }
}

struct ActivePickers: View {
    var activePickers: [String]
    
    var body: some View {
        VStack(spacing: 16) {
            // Title
            HStack {
                Title("Aktive plukkere")
                Spacer()
            }
            // Active employees
            ForEach(activePickers, id: \.self) { item in
                HStack {
                    Paragraph(item)
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PluckLobby_Previews: PreviewProvider {
    static var previews: some View {
        PluckLobby(token: "foo")
            .environmentObject(AuthenticationService())
            .environmentObject(PluckService())
    }
}
