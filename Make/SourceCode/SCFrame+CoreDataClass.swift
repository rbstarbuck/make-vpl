//
//  SCFrame+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import Foundation
import CoreData


public class SCFrame: NSManagedObject {
    
    lazy public var layerObserver: ObservableRelationship = {
        let context = SCCoreDataStack.instance.managedObjectContext
        return ObservableRelationship(entity: self, relatedEntityName: SCLayer.entityName,
                                      inverseRelationship: "frame", context: context)
    }()
    
}
