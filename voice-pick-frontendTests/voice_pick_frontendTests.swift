//
//  voice_pick_frontendTests.swift
//  voice-pick-frontendTests
//
//  Created by Petter Molnes on 10/02/2023.
//

import XCTest
@testable import voice_pick_frontend

final class voice_pick_frontendTests: XCTestCase {
	
	func testIsValidEmail() {
		let validator = Validator.shared
		
		// Test valid email
		XCTAssertTrue(validator.isValidEmail("test@example.com"))
		
		// Test invalid email
		XCTAssertFalse(validator.isValidEmail(""))
		XCTAssertFalse(validator.isValidEmail("test"))
		XCTAssertFalse(validator.isValidEmail("test@"))
		XCTAssertFalse(validator.isValidEmail("test@example"))
		XCTAssertFalse(validator.isValidEmail("test@.com"))
		XCTAssertFalse(validator.isValidEmail("@example.com"))
	}
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testExample() throws {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
		// Any test you write for XCTest can be annotated as throws and async.
		// Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
		// Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
	}
	
	func testPerformanceExample() throws {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
	
}
