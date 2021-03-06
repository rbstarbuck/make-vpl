//
//  SCCoreDataStack.swift
//  Make
//
//  Created by Richmond Starbuck on 12/21/16.
//
//

import Foundation
import CoreData


public class SCCoreDataStack: NSManagedObjectContext {
    public var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1] as NSURL
    }()
    
    public convenience init() {
        self.init(concurrencyType: .mainQueueConcurrencyType)
        
        let modelURL = Bundle.main.url(forResource: "SCModel", withExtension: "momd")!
        let objectModel = NSManagedObjectModel(contentsOf: modelURL)!
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SCModel.sqlite")
        do {
            // If your looking for any kind of migration then here is the time to pass it to the options
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        }
        catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
        }
        
        self.persistentStoreCoordinator = coordinator
    }
}
