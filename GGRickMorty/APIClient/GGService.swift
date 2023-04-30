//
//  GGService.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import Foundation

final class GGService {
    
    /// API Constants
    struct Constants {
        static let baseURL = "https://rickandmortyapi.com/api"
    }
    
    /// Singleton instance
    static let shared = GGService()
    
    /// Define a generic function to make an HTTP request
    public func makeRequest<T: Decodable>(endpoint: GGEndpoint, page: Int? = nil, method: HTTPMethod = .get, parameters: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        /// Create the URL based on the endpoint and page number
        var urlString = "\(GGService.Constants.baseURL)\(endpoint.path)"
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

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
