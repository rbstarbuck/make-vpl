//
//  SCSprite+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


extension SCSprite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCSprite> {
        return NSFetchRequest<SCSprite>(entityName: "Sprite");
    }

    @NSManaged public var scenes: NSSet?

}

// MARK: Generated accessors for scenes
extension SCSprite {

    @objc(addScenesObject:)
    @NSManaged public func addToScenes(_ value: SCScene)

    @objc(removeScenesObject:)
    @NSManaged public func removeFromScenes(_ value: SCScene)

    @objc(addScenes:)
    @NSManaged public func addToScenes(_ values: NSSet)

    @objc(removeScenes:)
    @NSManaged public func removeFromScenes(_ values: NSSet)

}
