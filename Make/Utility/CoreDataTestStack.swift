//
//  CoreDataTestStack.swift
//  Make
//
//  Created by Richmond Starbuck on 12/23/16.
//
//

import Foundation
import CoreData


public class CoreDataTestStack: NSManagedObjectContext {
    
    public lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1] as NSURL
    }()
    
    
    public convenience init() {
        self.init(concurrencyType: .mainQueueConcurrencyType)
        
        let objectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        do {
            // If your looking for any kind of migration then here is the time to pass it to the options
            try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        }
        catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
        }
        
        self.persistentStoreCoordinator = coordinator
    }
}
