//
//  LocationResults.swift
//  RickNMorty
//
//  Created by Kazuha on 30/04/23.
//

import Foundation

struct LocationResults: Codable {
    let info: Info
    let results: [LocationModel]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
