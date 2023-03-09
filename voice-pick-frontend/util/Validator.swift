//
//  Validators.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 17/02/2023.
//

import Foundation

/**
 Shared validator class with methods to validate input fields across the application.
 */
class Validator {
	///Singleton instance to share across application
	static let shared = Validator()
	
	///Regex for validating name fields
	private let nameRegex = "^[a-zA-ZæøåÆØÅ]+([ '-][a-zA-ZæøåÆØÅ]+)*$"
	
	///Private constructor to prevent instantiation
	private init() {}
	
	/**
	Check if email is valid.
	 
	```
	 You can use the method by calling it through the shared instance
	 with the syntax below:
	 
	 Validator().shared.isValidEmail("test@test.com") // true
	```
	- Parameters:
		- email: The email to validate
	 
	 - Returns: true if the email is valid, false otherwise.
	 */
	func isValidEmail(_ email: String) -> Bool {
		let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let emailValidation = NSPredicate(format: "SELF MATCHES %@", emailRegex)
		return emailValidation.evaluate(with: email)
	}
	
	/**
	Check if password is valid.
	 
	```
	 You can use the method by calling it through the shared instance
	 with the syntax below:
	 
	 Validator().shared.isPasswordValid("test") // false
	```
	- Parameters:
		- password: The password to validate
	 
	 - Returns: true if the password is valid, false otherwise.
	 */
	func isValidPassword(_ password: String) -> Bool {
		return password.count >= 6
	}
	
	/**
	 Checks if firstname is valid.
	 ```
		Use the method by calling it through the shared instance
		with the syntax below:
	 
		Validator().shared.isValidFirstname("test") // true
	 ```
	 - Parameters:
			- firstname: The firstname to validate
	 
	 - Returns: true if the firstname is valid, false otherwise.
	 */
	func isValidFirstname(_ firstname: String) -> Bool {
		let firstnameValidation = NSPredicate(format: "SELF MATCHES %@", nameRegex)
		return !firstname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && firstnameValidation.evaluate(with: firstname)
	}
	
	/**
	 Checks if lastname is valid.
	 ```
		Use the method by calling it through the shared instance
		with the syntax below:
	 
		Validator().shared.isValidLastname("test") // true
	 ```
	 - Parameters:
			- lastname: The firstname to validate
	 
	 - Returns: true if the lastname is valid, false otherwise.
	 */
	func isValidLastname(_ lastname: String) -> Bool {
		let lastnameValidation = NSPredicate(format: "SELF MATCHES %@", nameRegex)
		return !lastname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && lastnameValidation.evaluate(with: lastname)
	}
	
}
