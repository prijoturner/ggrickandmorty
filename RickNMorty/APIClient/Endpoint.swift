//
//  Endpoint.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import Foundation

/// API Endpoint
enum Endpoint {
    /// Endpoint to get character
    case character
    /// Endpoint to get location
    case location
    /// Endpoint to get episode
    case episode
    
    var path: String {
        switch self {
        case .character:
            return "/character"
        case .location:
            return "/location"
        case .episode:
            return "/episode"
        }
    }
}
