//
//  FavoriteRepository.swift
//  RickNMorty
//
//  Created by Kazuha on 04/11/25.
//

import CoreData

class FavoriteRepository {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - Fetch Methods
    func getFavoriteCharacters() -> [FavoriteCharacter] {
        let context = coreDataManager.context
        let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        
        do {
            let favorites = try context.fetch(fetchRequest)
            return favorites
        } catch {
            Logger.shared.error("Failed to fetch favorite characters: \(error)")
            return []
        }
    }
    
    // MARK: - Add/Remove Methods
    func addFavorite(_ character: FavoriteCharacter) -> Bool {
        let context = coreDataManager.context
        context.insert(character)
        coreDataManager.saveContext()
        return true
    }
    
    func removeFavorite(byName name: String) -> Bool {
        let context = coreDataManager.context
        let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let favorites = try context.fetch(fetchRequest)
            if let favorite = favorites.first {
                context.delete(favorite)
                coreDataManager.saveContext()
                return true
            }
            return false
        } catch {
            Logger.shared.error("Failed to remove favorite: \(error)")
            return false
        }
    }
    
    // MARK: - Check Methods
    func isFavorite(byName name: String) -> Bool {
        let context = coreDataManager.context
        let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            Logger.shared.error("Failed to check favorite status: \(error)")
            return false
        }
    }
}

