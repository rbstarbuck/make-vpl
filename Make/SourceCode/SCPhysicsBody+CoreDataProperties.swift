//
//  SCPhysicsBody+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 1/18/17.
//
//

import Foundation
import CoreData


extension SCPhysicsBody {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCPhysicsBody> {
        return NSFetchRequest<SCPhysicsBody>(entityName: "PhysicsBody");
    }
    
    @NSManaged public var isEnabled: Bool
    @NSManaged public var isDynamic: Bool
    @NSManaged public var isAffectedByGravity: Bool
    @NSManaged public var canRotate: Bool
    @NSManaged public var friction: Double
    @NSManaged public var restitution: Double
    @NSManaged public var density: Double
    @NSManaged public var linearDamping: Double
    @NSManaged public var angularDamping: Double

}
