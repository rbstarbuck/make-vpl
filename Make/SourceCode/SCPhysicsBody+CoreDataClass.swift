//
//  SCPhysicsBody+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 1/18/17.
//
//

import Foundation
import CoreData


@objc(SCPhysicsBody)
public class SCPhysicsBody: NSManagedObject {
    public static let entityName = "PhysicsBody"
    
    
    @NSManaged public var shape: SCPhysicsBodyShape
    @NSManaged public var sprite: SCSprite
    
}
