//
//  GGCharacterDetailViewModel.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import Foundation
import UIKit

final class GGCharacterDetailViewModel {
    
    // MARK: - Properties
    public var character: Character? = nil
    
    // MARK: - Computed Properties
    public var statusImageName: String? {
        guard let character = character else { return nil }
        switch character.status {
        case .alive:
            return "ic_alive"
        case .dead:
            return "ic_dead"
        case .unknown:
            return "ic_unknown"
        }
    }
    
    public var genderImageName: String? {
        guard let character = character else { return nil }
        switch character.gender {
        case .male:
            return "ic_male"
        case .female:
            return "ic_female"
        case .genderless, .unknown:
            return "ic_unknown"
        }
    }
    
    public func configure(_ imageView: UIImageView) {
        guard let character = character else { return }
        imageView.fetchImage(from: character.image)
    }
    
    public func configure(_ label: UILabel, for type: LabelType) {
        guard let character = character else { return }
        switch type {
        case .name:
            label.text = character.name
        case .status:
            label.text = "Status: \(character.status.rawValue)"
        case .gender:
            label.text = "Gender: \(character.gender.rawValue)"
        case .species:
            label.text = "Species: \(character.species)"
        case .created:
            let attributedText = character.created.attributedStringForCreatedText()
            label.attributedText = attributedText
        case .origin:
            label.text = "Origin: \(character.origin.name)"
        case .location:
            label.text = "Location: \(character.location.name)"
        }
    }
    
}

enum LabelType {
    case name
    case status
    case gender
    case species
    case created
    case origin
    case location
}

