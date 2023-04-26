//
//  LocationDetailsPage.swift
//  voice-pick-frontend
//
//  Created by tama on 25/04/2023.
//

import SwiftUI

struct LocationDetailsPage: View {
    
    
    @State var isEditing = false
    
    @State var code: String
    @State var controlDigits: Int
    @State var locationType: String
    
    
    var body: some View {
        Text(code)
        Text(locationType)
    }
}

struct LocationDetailsPage_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailsPage(code: "H101", controlDigits: 101, locationType: "PRODUKT")
    }
}
