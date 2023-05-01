//
//  GGEpisodeResutls.swift
//  GGRickMorty
//
//  Created by Kazuha on 01/05/23.
//

import Foundation

struct GGEpisodeResults: Codable {
    let info: Info
    let results: [GGEpisode]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
