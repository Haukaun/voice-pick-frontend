//
//  VerificaitonPage.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 15/02/2023.
//

import SwiftUI

struct VerificaitonPage: View {
	var buttonText = "Resend Email"
	
	var body: some View {
		VStack{
			ZStack{
				Image("Tracefavicon")
					.resizable()
					.frame(width: 120, height: 120)
					.opacity(0.05)
				VStack (spacing: -15){
					Text("TRACE").font(.guidelineHeading).foregroundColor(.traceMediYellow)
					Text("Voice pick").font(.header1).foregroundColor(.foregroundColor)
				}
			}
			Spacer()
			Group {
				Text("An email verification has been sent to your email!")
					.font(.header2)
					.foregroundColor(.foregroundColor)
					.multilineTextAlignment(.center)
				DefaultButton(buttonText: buttonText)
			}
			.padding(40)
			Spacer()
			Footer()
		}
		.padding(20)
	}
}

struct VerificaitonPage_Previews: PreviewProvider {
	static var previews: some View {
		VerificaitonPage()
	}
}
