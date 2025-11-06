//
//  CharacterDetailViewModel.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import Foundation
import Combine
import CoreData

final class CharacterDetailViewModel {
    
    // MARK: - Properties
    private var originalCharacter: CharacterModel?
    
    // MARK: - Published Properties
    @Published private(set) var displayCharacterDetail: CharacterDetailDisplayData?
    @Published private(set) var isFavorite: Bool = false
    
    // MARK: - Initialization
    init(character: CharacterModel? = nil) {
        if let character = character {
            self.originalCharacter = character
            self.displayCharacterDetail = character.toDetailDisplayData()
        }
    }
    
    // MARK: - Public Methods
    func configure(with character: CharacterModel) {
        self.displayCharacterDetail = character.toDetailDisplayData()
    }
    
    func numberOfEpisodes() -> Int {
        return displayCharacterDetail?.episodeURLs.count ?? 0
    }
    
    func episodeURL(at index: Int) -> String? {
        return displayCharacterDetail?.episodeURLs[index]
    }
    
    func checkIfFavorite() {
        guard let characterData = displayCharacterDetail else {
            isFavorite = false
            return
        }
        
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", characterData.name)
        
        do {
            let count = try context.count(for: fetchRequest)
            isFavorite = count > 0
        } catch {
            Logger.shared.error("Failed to check favorite status: \(error)")
            isFavorite = false
        }
    }
    
    func toggleFavorite(completion: @escaping (Bool, String) -> Void) {
        guard let characterData = displayCharacterDetail else {
            Logger.shared.error("No character data available")
            completion(false, "Failed to update favorites")
            return
        }
        
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", characterData.name)
        
        do {
            let existingFavorites = try context.fetch(fetchRequest)
            
            if let favorite = existingFavorites.first {
                context.delete(favorite)
                CoreDataManager.shared.saveContext()
                isFavorite = false
                completion(true, "\(characterData.name) removed from favorites!")
            } else {
                let favorite = FavoriteCharacter(context: context)
                guard let character = originalCharacter else {
                    completion(false, "Failed to get character data")
                    return
                }
                
                favorite.name = character.name
                favorite.status = character.status.rawValue
                favorite.species = character.species
                favorite.gender = character.gender.rawValue
                favorite.imageURL = character.image
                favorite.origin = character.origin.name
                favorite.location = character.location.name
                favorite.created = character.created
                favorite.episodes = character.episode as NSArray
                
                CoreDataManager.shared.saveContext()
                isFavorite = true
                completion(true, "\(characterData.name) added to favorites!")
            }
            
        } catch {
            Logger.shared.error("Failed to toggle favorite: \(error)")
            completion(false, "Failed to update favorites")
        }
    }
    
}
