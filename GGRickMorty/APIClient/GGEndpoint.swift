//
//  GGEndpoint.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import Foundation

/// API Endpoint
enum GGEndpoint {
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
