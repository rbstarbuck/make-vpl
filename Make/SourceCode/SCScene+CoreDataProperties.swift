//
//  SCScene+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


extension SCScene {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCScene> {
        return NSFetchRequest<SCScene>(entityName: "Scene");
    }

    @NSManaged public var sprites: NSSet?
    @NSManaged public var world: SCWorld?

}

// MARK: Generated accessors for sprites
extension SCScene {

    @objc(addSpritesObject:)
    @NSManaged public func addToSprites(_ value: SCSprite)

    @objc(removeSpritesObject:)
    @NSManaged public func removeFromSprites(_ value: SCSprite)

    @objc(addSprites:)
    @NSManaged public func addToSprites(_ values: NSSet)

    @objc(removeSprites:)
    @NSManaged public func removeFromSprites(_ values: NSSet)

}
