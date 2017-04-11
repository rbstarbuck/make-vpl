//
//  SCPhysicsBody+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 1/18/17.
//
//

import Foundation
import SpriteKit
import CoreData


@objc(SCPhysicsBody)
public class SCPhysicsBody: NSManagedObject {
    public static let entityName = "PhysicsBody"
    
    
    @NSManaged public var shape: SCPhysicsBodyShape
    @NSManaged public var isEnabled: Bool
    @NSManaged public var isDynamic: Bool
    @NSManaged public var isAffectedByGravity: Bool
    @NSManaged public var canRotate: Bool
    @NSManaged public var friction: Double
    @NSManaged public var restitution: Double
    @NSManaged public var density: Double
    @NSManaged public var linearDamping: Double
    @NSManaged public var angularDamping: Double
    @NSManaged public var sprite: SCSprite
    
    
    public override func awakeFromInsert() {
        self.shape = SCPhysicsBodyShapeCircle()
    }
    
}
