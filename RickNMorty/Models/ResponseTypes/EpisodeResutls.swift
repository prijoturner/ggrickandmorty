//
//  EpisodeResutls.swift
//  RickNMorty
//
//  Created by Kazuha on 01/05/23.
//

import Foundation

struct EpisodeResults: Codable {
    let info: Info
    let results: [EpisodeModel]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
