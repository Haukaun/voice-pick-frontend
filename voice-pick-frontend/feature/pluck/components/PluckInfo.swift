//
//  PluckInfo.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 16/02/2023.
//

import SwiftUI

struct PluckInfo: View {
    
    @State var plucks: [Pluck]
    
    var body: some View {
        VStack {
            Text("Pluck info")
        }
    }
}

struct PluckInfo_Previews: PreviewProvider {
    static var previews: some View {
        PluckInfo(plucks: [])
    }
}
