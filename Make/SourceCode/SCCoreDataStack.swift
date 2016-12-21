//
//  SCCoreDataStack.swift
//  Make
//
//  Created by Richmond Starbuck on 12/21/16.
//
//

import Foundation
import CoreData


class SCCoreDataStack {
    static var instance = SCCoreDataStack()
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "SCModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SCModel.sqlite")
        do {
            // If your looking for any kind of migration then here is the time to pass it to the options
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }()
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("ERROR: \(error.localizedDescription)")
                abort() 
            }
        }
    }
}
