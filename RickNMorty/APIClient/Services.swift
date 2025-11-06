//
//  Services.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import Foundation

/// A networking service layer that handles HTTP requests to the Rick and Morty API.
///
/// `Services` provides a generic, type-safe interface for making network requests
/// with automatic JSON decoding. It implements the singleton pattern for consistent
/// network configuration throughout the application.
///
/// ## Usage Example
/// ```swift
/// Services.shared.makeRequest(endpoint: .character, page: 1) { (result: Result<CharacterResults, Error>) in
///     switch result {
///     case .success(let data):
///         print("Received \(data.results.count) characters")
///     case .failure(let error):
///         print("Error: \(error)")
///     }
/// }
/// ```
final class Services {
    
    /// Contains API-related constant values.
    struct Constants {
        /// The base URL for the Rick and Morty API.
        static let baseURL = "https://rickandmortyapi.com/api"
    }
    
    /// Shared singleton instance of Services.
    static let shared = Services()
    
    /// Makes a generic HTTP request to the specified endpoint.
    ///
    /// This method handles URL construction, request creation, network execution,
    /// and automatic JSON decoding to the specified type.
    ///
    /// - Parameters:
    ///   - endpoint: The API endpoint to request.
    ///   - page: Optional page number for paginated endpoints.
    ///   - method: The HTTP method to use. Default is `.get`.
    ///   - parameters: Optional dictionary of parameters for POST requests.
    ///   - completion: A closure called with the result containing either the decoded data or an error.
    /// - Note: The generic type `T` must conform to `Decodable`.
    public func makeRequest<T: Decodable>(endpoint: Endpoint, page: Int? = nil, method: HTTPMethod = .get, parameters: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        /// Create the URL based on the endpoint and page number
        var urlString = "\(Services.Constants.baseURL)\(endpoint.path)"
        if let page = page {
            urlString += "?page=\(page)"
        }
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURLDomain", code: -1, userInfo: nil)))
            return
        }
        
        /// Create a URL request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if method == .post {
            if let parameters = parameters {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                } catch let error {
                    completion(.failure(error))
                    return
                }
            }
        }
        
        /// Create a URL session
        let session = URLSession.shared
        
        /// Make the HTTP request
        let task = session.dataTask(with: request) { data, response, error in
            /// Check for errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            /// Check for a valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "HTTPErrorDomain", code: -1, userInfo: nil)))
                return
            }
            
            /// Check for valid response data
            guard let data = data else {
                completion(.failure(NSError(domain: "DataErrorDomain", code: -1, userInfo: nil)))
                return
            }
            
            /// Parse the response data as a generic type
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}

/// Defines the HTTP methods supported by the Services layer.
enum HTTPMethod: String {
    /// HTTP GET method for retrieving data.
    case get = "GET"
    /// HTTP POST method for creating data.
    case post = "POST"
    /// HTTP PUT method for updating data.
    case put = "PUT"
    /// HTTP DELETE method for deleting data.
    case delete = "DELETE"
}
