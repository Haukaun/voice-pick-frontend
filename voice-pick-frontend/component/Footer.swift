//
//  Footer.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 15/02/2023.
//

import SwiftUI

struct Footer: View {
    var body: some View {
			//TODO: ADD white image for dark theme.
			VStack (spacing: -20){
				Image("SOLWR")
					.resizable()
					.frame(width: 100, height: 80)
					.opacity(0.2)
				Text("Copyright @2022 \n Version 0.0.1")
					.multilineTextAlignment(.center)
					.opacity(0.2)
			}
    }
}

struct Footer_Previews: PreviewProvider {
    static var previews: some View {
        Footer()
    }
}
