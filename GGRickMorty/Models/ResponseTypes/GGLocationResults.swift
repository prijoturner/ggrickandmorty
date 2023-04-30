//
//  GGLocation.swift
//  GGRickMorty
//
//  Created by Kazuha on 30/04/23.
//

import Foundation

struct GGLocationResults: Codable {
    let info: Info
    let results: [GGLocation]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
