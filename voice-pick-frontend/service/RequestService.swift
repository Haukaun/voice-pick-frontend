//
//  RequestService.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 02/03/2023.
//

import Foundation
import OSLog

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
		apiBaseUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as! String
	}
	
	/// Makes a request to the base api
	///
	/// - Parameters:
	///     - method: The type of the request (get, post, put or delete)
	///     - path: The relative path to the api endpoint
	///     - body: The body of the response. This is optional and is not used in case of a get request
	///     - responseType: The type of the expected response
	private func request<T: Codable, U: Codable>(_ method: String, _ path: String, _ token: String? = nil, _ body: T?, _ responseType: U.Type, _ completion: @escaping (Result<U, Error>) -> Void) {
		DispatchQueue.main.async {
			self.isLoading = true
		}
		
		guard let url = URL(string: apiBaseUrl + path) else {
			DispatchQueue.main.async {
				self.isLoading = false
			}
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
				DispatchQueue.main.async {
					self.isLoading = false
				}
				completion(.failure(RequestError(errorMessage: "Error encoding body, make sure it is in correct format.", errorType: .decodeError)))
			}
		}
		
		urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
		urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
		urlRequest.setValue("IOS", forHTTPHeaderField: "CHANNEL")
		
		if token != nil {
			urlRequest.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
		}
		
		let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			// handles errors where the request could not be sent, (ex: api is down)
			if let error = error {
				DispatchQueue.main.async {
					self.isLoading = false
				}
				completion(.failure(error))
				return
			}
			
			guard let data = data else {
				DispatchQueue.main.async {
					self.isLoading = false
				}
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
						DispatchQueue.main.async {
							self.isLoading = false
						}
						completion(.failure(RequestError(errorType: .decodeError)))
						return
					}
					DispatchQueue.main.async {
						self.isLoading = false
					}
					completion(.success(result))
				} else {
					// Here we did not have a status code of success.
					if let errorMsg = String(data: data, encoding: .utf8) {
						DispatchQueue.main.async {
							self.isLoading = false
						}
						completion(.failure(RequestError(errorCode: httpResponse.statusCode, errorMessage: errorMsg, errorType: .responseError)))
					}
				}
			}
		}
		task.resume()
	}
	
	/**
	 Returns an object of type U. The object has to conform `Codable` so it can be mapped to from json
	 
	 - Parameters:
	 - path: The raltive path to the endpoint
	 - token: A jwt token that should be added to the headers
	 - responseType: The type of the response you expect to get
	 - completion: A function that is called whenever the request is completed. Should handle both success and error conditions
	 */
	func get<U: Codable>(path: String, token: String? = nil, responseType: U.Type, completion: @escaping (Result<U, Error>) -> Void) {
		request(
			"GET",
			path,
			token,
			nil as String?,
			responseType,
			completion
		)
	}
	
	/**
	 Returns an object of type U. The object has to conform to `Codable` so it can be mapped to and from JSON
	 
	 - Parameters:
	 - path: The relative path to the endpoint
	 - token: A jwt token that should be added to the headers
	 - body: The additional information as type T to attach the requets body
	 - responseType: The type of the response you expect to get
	 - completion: A function that is called whenever the request is completed. Should handle both success and error conditions
	 */
	func post<T: Codable, U: Codable>(path: String, token: String? = nil, body: T, responseType: U.Type, completion: @escaping (Result<U, Error>) -> Void) {
		request(
			"POST",
			path,
			token,
			body,
			responseType,
			completion
		)
	}

    /**
     Delete request with body
    */
	func delete<T:Codable, U: Codable>(path: String, token: String? = nil, body: T, responseType: U.Type, completion: @escaping (Result<U, Error>) -> Void) {
        request(
            "DELETE",
            path,
            token,
            body,
            responseType,
            completion
        )
	}
    
    /**
     Delete request without body
     */
    func delete<U: Codable>(path: String, token: String? = nil, responseType: U.Type, completion: @escaping (Result<U, Error>) -> Void) {
        request(
            "DELETE",
            path,
            token,
            nil as String?,
            responseType,
            completion
        )
    }
    
    func patch<T:Codable, U: Codable>(path: String, token: String? = nil, body: T, responseType: U.Type, completion: @escaping (Result<U, Error>) -> Void) {
        request(
            "PATCH",
            path,
            token,
            body,
            responseType,
            completion
        )
    }
    
    func introspectAuthentication(authService: AuthenticationService) {
            post(
                path: "/auth/introspect",
                body: TokenRequest(token: authService.accessToken),
                responseType: String.self,
                completion: { result in
                    switch result {
                    case .success(_):
                        os_log("Valid token")
                    case .failure(_):
                        authService.logout()
                    }
                })
        }
}
