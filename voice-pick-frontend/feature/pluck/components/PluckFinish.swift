//
//  PluckFinish.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 20/02/2023.
//

import SwiftUI

struct PluckFinish: View {
	
	
	@State private var selectedNumber: Int?
	
	//TODO: This value should not be hardcoded, only for testing.
	@State private var correctAnswer: Int? = 243
	
	@State private var isAnswerSelected = false
	
	var body: some View {
		VStack {
			Card(){
				VStack (alignment: .leading){
					HStack {
						Title("Fullfør plukk")
						Spacer()
					}
					.padding(.bottom)
					Paragraph("Plukker")
					
					//TODO: Fix username varibale
					Paragraph("Username")
						.bold()
						.padding(.bottom)
					Paragraph("Leverings lokasjon")
					Paragraph("ML-123")
						.bold()
						.padding(.bottom)
					if(!isAnswerSelected){
						Group{
							Divider()
								.padding(.bottom)
							Paragraph("Velg kontrollsiffer")
								.bold()
							HStack (spacing: 10){
								//TODO: Fix correctAnswer backend variable
								ButtonRandomizer(correctAnswer: correctAnswer!){ number in
									selectedNumber = number
									withAnimation(){
										isAnswerSelected = true
									}
								}
							}
						}
					}
				}
			}
			
			VStack (spacing: 5) {
				Spacer()
				Paragraph("Før avlevering:")
					.bold()
				Paragraph("Pakk pallen inn i plast")
				Paragraph("Sett på lapper på alle sider")
				Spacer()
				DefaultButton("Fullfør", disabled: selectedNumber != correctAnswer){
					
				}
			}
		}
		.padding(10)
	}
}

struct PluckFinish_Previews: PreviewProvider {
	static var previews: some View {
		PluckFinish()
	}
}
