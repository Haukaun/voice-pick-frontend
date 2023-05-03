//
//  ButtonRandomizer.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 22/02/2023.
//

import SwiftUI

/**
 Randomizes 3 buttons where one of the buttons is correct. If the answer is wrong the button will display red.
 */
struct ButtonRandomizer: View {
	let possibleNumbers: [Int]
	let correctAnswer: Int
	let onCorrectAnswerSelected: (Int) -> Void
	let disableButtons: Bool
	@State private var selectedAnswer: Int?
	
	
	@State private var isAnswerSelected = false
	
	init(correctAnswer: Int, onCorrectAnswerSelected: @escaping (Int) -> Void, disableButtons: Bool) {
		self.correctAnswer = correctAnswer
		
		// Generate two random numbers between 0 and 9, excluding the correct answer
		let random1 = Int.random(in: 100..<999)
		let random2 = Int.random(in: 100..<999)
		let randomNumbers = [random1, random2, correctAnswer]
		
		// Shuffle the array of random numbers
		self.possibleNumbers = randomNumbers.shuffled()
		
		self.onCorrectAnswerSelected = onCorrectAnswerSelected
		self.disableButtons = disableButtons
	}
	
	var body: some View {
		VStack(alignment: .leading) {
			Paragraph("Velg kontrollsiffer")
				.bold()
			HStack (spacing: 5) {
				ForEach(possibleNumbers, id: \.self) { number in
					Button(action: { onNumberSelected(number) }) {
						Spacer()
						Text("\(number)")
							.padding(15)
							.fontWeight(.bold)
							.font(.button)
							.foregroundColor(isWrongAnswer(number) ? Color.snow : Color.backgroundColor)
						Spacer()
					}
					.background(
						isWrongAnswer(number) ? Color.error: Color.foregroundColor
					)
					.cornerRadius(UIView.standardCornerRadius)
					.disabled(disableButtons)
					.opacity(disableButtons ? 0.5 : 1)
				}
			}
		}
		.buttonStyle(BorderlessButtonStyle())
	}
	
	/**
	 Selects numbers and check if it is the correct one
	 */
	private func onNumberSelected(_ number: Int) {
		selectedAnswer = number
		if number == correctAnswer {
			onCorrectAnswerSelected(number)
		}
	}
	
	/**
	 Checks if the answer selected is wrong
	 */
	private func isWrongAnswer(_ possibleNumber: Int) -> Bool {
		if let selectedAnswer = selectedAnswer, selectedAnswer != correctAnswer && possibleNumber == selectedAnswer {
			return true
		}
		return false
	}
}

struct ButtonRandomizer_Previews: PreviewProvider {
	static var previews: some View {
		ButtonRandomizer(correctAnswer: 293, onCorrectAnswerSelected: { number in
			print(number)
		}, disableButtons: false)
		.padding(10)
	}
}
