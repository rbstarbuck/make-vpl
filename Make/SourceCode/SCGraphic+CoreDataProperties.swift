//
//  SCGraphic+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import Foundation
import CoreData


extension SCGraphic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCGraphic> {
        return NSFetchRequest<SCGraphic>(entityName: "Graphic");
    }

    @NSManaged public var animationFPS: Double

}

// MARK: Generated accessors for frames
extension SCGraphic {

    @objc(insertObject:inFramesAtIndex:)
    @NSManaged public func insertIntoFrames(_ value: SCFrame, at idx: Int)

    @objc(removeObjectFromFramesAtIndex:)
    @NSManaged public func removeFromFrames(at idx: Int)

    @objc(insertFrames:atIndexes:)
    @NSManaged public func insertIntoFrames(_ values: [SCFrame], at indexes: NSIndexSet)

    @objc(removeFramesAtIndexes:)
    @NSManaged public func removeFromFrames(at indexes: NSIndexSet)

    @objc(replaceObjectInFramesAtIndex:withObject:)
    @NSManaged public func replaceFrames(at idx: Int, with value: SCFrame)

    @objc(replaceFramesAtIndexes:withFrames:)
    @NSManaged public func replaceFrames(at indexes: NSIndexSet, with values: [SCFrame])

    @objc(addFramesObject:)
    @NSManaged public func addToFrames(_ value: SCFrame)

    @objc(removeFramesObject:)
    @NSManaged public func removeFromFrames(_ value: SCFrame)

    @objc(addFrames:)
    @NSManaged public func addToFrames(_ values: NSOrderedSet)

    @objc(removeFrames:)
    @NSManaged public func removeFromFrames(_ values: NSOrderedSet)

}

// MARK: Generated accessors for sprites
extension SCGraphic {

    @objc(addSpritesObject:)
    @NSManaged public func addToSprites(_ value: SCSprite)

    @objc(removeSpritesObject:)
    @NSManaged public func removeFromSprites(_ value: SCSprite)
    
    @objc(addSprites:)
    @NSManaged public func addToSprites(_ values: NSSet)
    
    @objc(removeSprites:)
    @NSManaged public func removeFromSprites(_ values: NSSet)

}
