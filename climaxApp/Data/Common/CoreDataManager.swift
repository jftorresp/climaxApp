//
//  CoreDataManager.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 2/02/25.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    init() {
        container = NSPersistentContainer(name: "ClimaxAppModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error while loading Core Data: \(error)")
            }
        }
    }
    
    func saveContext() throws {
        try context.save()
    }
    
    func deleteContext(object: NSManagedObject) {
        context.delete(object)
    }
}
