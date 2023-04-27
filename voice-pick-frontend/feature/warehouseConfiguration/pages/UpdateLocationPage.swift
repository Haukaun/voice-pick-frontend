//
//  UpdateLocationPage.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 27/04/2023.
//

import SwiftUI

struct UpdateLocationPage: View {
	
	@State var location: Location
	
    var body: some View {
			Text(location.code)
    }
	
}

struct UpdateLocationPage_Previews: PreviewProvider {
		
	
    static var previews: some View {
			UpdateLocationPage(location: Location(code: "123", controlDigits: 123, locationType: "PRODUCT"))
    }
}
