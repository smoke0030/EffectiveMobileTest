//
//  Persistence.swift
//  EffectiveMobileTest
//
//  Created by Сергей on 27.08.2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let containter: NSPersistentContainer
    
    init() {
        self.containter = NSPersistentContainer(name: "TodoDataModel")
        
        
        containter.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
