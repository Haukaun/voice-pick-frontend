//
//  RequestService.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 02/03/2023.
//

import Foundation

struct RequestError: Error {
	enum RequestErrorType {
		case urlError
		case dataError
		case decodeError
		case responseError
	}
	var errorCode: Int = 0
	var errorMessage: String = ""
	let errorType: RequestErrorType
}

/// A service class exposing method to make api calls
///
/// Created by Joakim Edvardsen on 02/03/2023
class RequestService: ObservableObject {
	
	@Published var isLoading = false;
	
	private var apiBaseUrl: String
	
	init() {
		let activeDev = Bundle.main.object(forInfoDictionaryKey: "DEV") as! String
		
		if (activeDev == "true") {
			apiBaseUrl = "http://localhost:8080"
		} else {
			apiBaseUrl = "https://api.bachelor.seq.re"
		}
	}
	
	/// Makes a request to the base api
	///
	/// - Parameters:
	///     - method: The type of the request (get, post, put or delete)
	///     - path: The relative path to the api endpoint
	///     - body: The body of the response. This is optional and is not used in case of a get request
	///     - responseType: The type of the expected response
	private func request<T: Codable, U: Codable>(_ method: String, _ path: String, _ body: T?, _ responseType: U.Type, _ completion: @escaping (Result<U, Error>) -> Void) {
		self.isLoading = true;
		
		guard let url = URL(string: apiBaseUrl + path) else {
			self.isLoading = false;
			return
		}
		
		var urlRequest = URLRequest(url: url)
		
		urlRequest.httpMethod = method
		
		if (body != nil && method != "GET") {
			let encoder = JSONEncoder()
			do {
				let data = try encoder.encode(body)
				urlRequest.httpBody = data
			} catch {
				self.isLoading = false
				completion(.failure(RequestError(errorMessage: "Error encoding body, make sure it is in correct format.", errorType: .decodeError)))
			}
		}
		
		urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
		urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
		urlRequest.setValue("IOS", forHTTPHeaderField: "CHANNEL")
		
		let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			// handles errors where the request could not be sent, (ex: api is down)
			if let error = error {
				self.isLoading = false
				completion(.failure(error))
				return
			}
			
			guard let data = data else {
				self.isLoading = false
				completion(.failure(RequestError(errorType: .dataError)))
				return
			}
			
			if let httpResponse = response as? HTTPURLResponse {
				// Checks if response has a status code of success
				if (200...299).contains(httpResponse.statusCode) {
					var result: U?
					if responseType == String.self {
						// If the expected response is a String, we dont decode it bc that can cause bugs
						result = String(data: data, encoding: .utf8) as! U?
					} else {
						result = try? JSONDecoder().decode(responseType, from: data)
					}
					guard let result = result else {
						self.isLoading = false
						completion(.failure(RequestError(errorType: .decodeError)))
						return
					}
					self.isLoading = false
					completion(.success(result))
				} else {
					// Here we did not have a status code of success.
					if let errorMsg = String(data: data, encoding: .utf8) {
						self.isLoading = false
						completion(.failure(RequestError(errorCode: httpResponse.statusCode, errorMessage: errorMsg, errorType: .responseError)))
					}
				}
			}
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
		func post<U: Codable, T: Codable>(path: String, body: T, responseType: U.Type, completion: @escaping (Result<U, Error>) -> Void) {
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
