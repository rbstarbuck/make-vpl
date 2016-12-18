//
//  SCWorld+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


extension SCWorld {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCWorld> {
        return NSFetchRequest<SCWorld>(entityName: "World");
    }

    @NSManaged public var scenes: NSOrderedSet?

}

// MARK: Generated accessors for scenes
extension SCWorld {

    @objc(insertObject:inScenesAtIndex:)
    @NSManaged public func insertIntoScenes(_ value: SCScene, at idx: Int)

    @objc(removeObjectFromScenesAtIndex:)
    @NSManaged public func removeFromScenes(at idx: Int)

    @objc(insertScenes:atIndexes:)
    @NSManaged public func insertIntoScenes(_ values: [SCScene], at indexes: NSIndexSet)

    @objc(removeScenesAtIndexes:)
    @NSManaged public func removeFromScenes(at indexes: NSIndexSet)

    @objc(replaceObjectInScenesAtIndex:withObject:)
    @NSManaged public func replaceScenes(at idx: Int, with value: SCScene)

    @objc(replaceScenesAtIndexes:withScenes:)
    @NSManaged public func replaceScenes(at indexes: NSIndexSet, with values: [SCScene])

    @objc(addScenesObject:)
    @NSManaged public func addToScenes(_ value: SCScene)

    @objc(removeScenesObject:)
    @NSManaged public func removeFromScenes(_ value: SCScene)

    @objc(addScenes:)
    @NSManaged public func addToScenes(_ values: NSOrderedSet)

    @objc(removeScenes:)
    @NSManaged public func removeFromScenes(_ values: NSOrderedSet)

}
