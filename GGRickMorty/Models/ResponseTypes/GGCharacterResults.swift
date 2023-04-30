//
//  GGCharacterResults.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import Foundation

struct GGCharacterResults: Codable {
    let info: Info
    let results: [GGCharacter]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
