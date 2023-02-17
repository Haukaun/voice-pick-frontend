//
//  AccountPage.swift
//  voice-pick-frontend
//
//  Created by tama on 17/02/2023.
//

import SwiftUI
struct AccountPage: View {
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: -15) {
                
            }
            Spacer()
            Footer()
        }
        .padding(50)
        .background(Color.backgroundColor)
    }
}

struct AccountPage_Previews: PreviewProvider {
    static var previews: some View {
        AccountPage()
    }
}
