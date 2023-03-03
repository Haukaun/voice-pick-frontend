//
//  RequestService.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 02/03/2023.
//

import Foundation

enum RequestError: Error {
	case urlError
	case dataError
}

/// A service class exposing method to make api calls
///
/// Created by Joakim Edvardsen on 02/03/2023
class RequestService: ObservableObject {
	let API_BASE_URL = "https://api.bachelor.seq.re"
	
	/// Makes a request to the base api
	///
	/// - Parameters:
	///     - method: The type of the request (get, post, put or delete)
	///     - path: The relative path to the api endpoint
	///     - body: The body of the response. This is optional and is not used in case of a get request
	///     - responseType: The type of the expected response
	private func request<T, U: Codable>(_ method: String, _ path: String, _ body: T?, _ responseType: U.Type, _ completion: @escaping (Result<U, Error>) -> Void) {
		guard let url = URL(string: API_BASE_URL + path) else {
			return
		}
		
		var urlRequest = URLRequest(url: url)
		
		urlRequest.httpMethod = method
		
		// TODO: Add body to request if there actually is a body
		
		urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
		urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
		urlRequest.setValue("IOS", forHTTPHeaderField: "CHANNEL")
		
		let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let data = data else {
				completion(.failure(RequestError.dataError))
				return
			}
			
			let response = try? JSONDecoder().decode(responseType, from: data)
			guard let response = response else {
				completion(.failure(RequestError.dataError))
				return
			}
			completion(.success(response))
		}
		
		task.resume()
	}
	
	/// Returns an object of type U. The object has to conform `Codable` so it can be mapped to from json
	///
	/// - Parameters:
	///     - path: The relative path to the endpoint
	///     - responseType: The type of the response you expect to get
	///     - completion: A function that is called whenever the request is completed. Should handle both success and error conditions
	func get<U: Codable>(path: String, responseType: U.Type, completion: @escaping (Result<U, Error>) -> Void) {
		request(
			"GET",
			path,
			nil as String?,
			responseType,
			completion
		)
	}
	
	/**
	 Returns an object of type U. The object has to conform to `Codable` so it can be mapped to and from JSON
	 
	 - Parameters:
	 - path: The relative path to the endpoint
	 - body: The additional information as type T to attach the requets body
	 - responseType: The type of the response you expect to get
	 - completion: A function that is called whenever the request is completed. Should handle both success and error conditions
	 */
	func post<U: Codable, T>(path: String, body: T, responseType: U.Type, completion: @escaping (Result<U, Error>) -> Void) {
		request(
			"POST",
			path,
			body,
			responseType,
			completion
		)
	}
	
	// TODO: Make functions for post, put and delete
	
}
