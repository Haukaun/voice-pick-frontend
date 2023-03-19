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
	@State private var selectedAnswer: Int?
	
	
	@State private var isAnswerSelected = false
	
	var body: some View {
		HStack (spacing: 5) {
			ControlNumberButton(possibleNumber: "\(possibleNumbers[0])", onPress: {
				onNumberSelected(possibleNumbers[0])}, wrongAnswer: isWrongAnswer(possibleNumbers[0]))
			ControlNumberButton(possibleNumber: "\(possibleNumbers[1])", onPress: { onNumberSelected(possibleNumbers[1])}, wrongAnswer: isWrongAnswer(possibleNumbers[1]))
			ControlNumberButton(possibleNumber: "\(possibleNumbers[2])", onPress: { onNumberSelected(possibleNumbers[2])}, wrongAnswer: isWrongAnswer(possibleNumbers[2]))
		}
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
