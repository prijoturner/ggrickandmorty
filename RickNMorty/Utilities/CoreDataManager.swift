//
//  CoreDataManager.swift
//  RickNMorty
//
//  Created by Kazuha on 04/11/25.
//

import CoreData

/// Manages Core Data stack and provides access to the persistent container and context.
///
/// `CoreDataManager` implements the singleton pattern to ensure a single source of truth
/// for Core Data operations throughout the application.
///
/// ## Usage Example
/// ```swift
/// let context = CoreDataManager.shared.context
/// // Perform Core Data operations
/// CoreDataManager.shared.saveContext()
/// ```
class CoreDataManager {
    /// Shared singleton instance of CoreDataManager.
    static let shared = CoreDataManager()

    /// The persistent container that encapsulates the Core Data stack.
    ///
    /// Lazily initialized with the "FavoriteDataModel" name. Crashes the app if the persistent stores
    /// cannot be loaded, as this is a critical failure.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteDataModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    /// The main managed object context associated with the persistent container.
    ///
    /// This context runs on the main queue and should be used for UI-related operations.
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    /// Saves changes in the managed object context if there are any.
    ///
    /// This method checks if the context has changes before attempting to save,
    /// preventing unnecessary write operations. Crashes the app if the save fails,
    /// as this indicates a critical data integrity issue.
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
