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
    
    public func fetchEntities<T>(_ request: NSFetchRequest<T>) -> [T]? {
        do {
            return try self.context.fetch(request)
        }
        catch let error {
            debugPrint("ERROR: couldn't fetch entities from connector: \(error.localizedDescription)")
        }
        return nil
    }
    
    public func createWorld() -> SCWorld {
        let world: SCWorld = self.createEntity(SCWorld.entityName)!
        world.connector = self
        let initialScene = world.createScene()
        world.initialScene = initialScene.id
        return world
    }
    
    public func getWorlds() -> [SCWorld] {
        let request: NSFetchRequest<SCWorld> = SCWorld.fetchRequest()
        do {
            let worlds = try self.context.fetch(request)
            for world in worlds {
                world.connector = self
            }
            return worlds
        }
        catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
        }
        
        return []
    }

}

