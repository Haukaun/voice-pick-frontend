//
//  Header.swift
//  voice-pick-frontend
//
//  Created by tama on 17/02/2023.
//

import SwiftUI

struct Header: View {
    var headerText: String
    
    var body: some View {
        VStack {
            HStack {
            Spacer()
            Text(headerText)
                .fontWeight(.bold)
                .font(.button)
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
        .foregroundColor(.night)
        .background(Color.traceLightYellow)
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .top
        )
        .offset(y: 0)
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(headerText:"Ankara")
    }
}
