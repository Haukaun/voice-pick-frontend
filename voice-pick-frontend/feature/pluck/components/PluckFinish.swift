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
	
	struct ButtonRandomizer: View {
		let possibleNumbers: [Int]
		let correctAnswer: Int
		let onCorrectAnswerSelected: (Int) -> Void
		@State private var selectedAnswer: Int?
		
		var body: some View {
				 HStack (spacing: 5) {
						 ButtonView(possibleNumber: "\(possibleNumbers[0])", onPress: {
								 onNumberSelected(possibleNumbers[0])}, wrongAnswer: isWrongAnswer(possibleNumbers[0]))
						 ButtonView(possibleNumber: "\(possibleNumbers[1])", onPress: { onNumberSelected(possibleNumbers[1])}, wrongAnswer: isWrongAnswer(possibleNumbers[1]))
						 ButtonView(possibleNumber: "\(possibleNumbers[2])", onPress: { onNumberSelected(possibleNumbers[2])}, wrongAnswer: isWrongAnswer(possibleNumbers[2]))
				 }
		 }
		
		private func onNumberSelected(_ number: Int) {
			selectedAnswer = number
			if number == correctAnswer {
				onCorrectAnswerSelected(number)
			}
		}
		
		private func isWrongAnswer(_ possibleNumber: Int) -> Bool {
						if let selectedAnswer = selectedAnswer, selectedAnswer != correctAnswer && possibleNumber == selectedAnswer {
								return true
						}
						return false
				}
		
		init(correctAnswer: Int, onCorrectAnswerSelected: @escaping (Int) -> Void) {
			self.correctAnswer = correctAnswer
			
			// Generate two random numbers between 0 and 9, excluding the correct answer
			let random1 = Int.random(in: 100..<999)
			let random2 = Int.random(in: 100..<999)
			let randomNumbers = [random1, random2, correctAnswer]
			
			// Shuffle the array of random numbers
			self.possibleNumbers = randomNumbers.shuffled()
			
			self.onCorrectAnswerSelected = onCorrectAnswerSelected
		}
	}
}

struct PluckFinish_Previews: PreviewProvider {
	static var previews: some View {
		PluckFinish()
	}
}

struct ButtonView: View {
		let possibleNumber: String
		var onPress: () -> Void
		var wrongAnswer: Bool
		
		var body: some View {
				Button(action: onPress) {
						Spacer()
						Text("\(possibleNumber)")
								.padding(15)
								.fontWeight(.bold)
								.font(.button)
								.foregroundColor(.snow)
						Spacer()
				}
				.background(
						wrongAnswer
								? Color.error
								: Color.night
				)
				.cornerRadius(UIView.standardCornerRadius)
		}
}
