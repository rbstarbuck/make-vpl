//
//  SCConnector.swift
//  Make
//
//  Created by Richmond Starbuck on 12/23/16.
//
//

import Foundation
import CoreData


public class SCConnector {
    
    public var context: NSManagedObjectContext
    
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    @discardableResult
    public func saveContext() -> Bool {
        if self.context.hasChanges {
            do {
                try self.context.save()
            }
            catch let error as NSError {
                print("ERROR: \(error.localizedDescription)")
                return false
            }
        }
        return true
    }
    
    public func createEntity<T>(_ entityName: String) -> T? {
        var entity: T? = nil
        if let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: self.context) {
            let managedObject = NSManagedObject(entity: entityDescription, insertInto: self.context)
            entity = managedObject as? T
            if entity == nil {
                print("ERROR: couldn't cast \(entityName) to provided type")
            }
        }
        else {
            print("ERROR: couldn't create EntityDescription for \(entityName)")
        }
        return entity
    }
    
    public func createWorld() -> SCWorld {
        let world: SCWorld = self.createEntity(SCWorld.entityName)!
        world.connector = self
        world.createScene()
        return world
    }

}

