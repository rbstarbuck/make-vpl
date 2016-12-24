//
//  SCGraphic+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/23/16.
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

    @objc(addFramesObject:)
    @NSManaged public func addToFrames(_ value: SCFrame)

    @objc(removeFramesObject:)
    @NSManaged public func removeFromFrames(_ value: SCFrame)

    @objc(addFrames:)
    @NSManaged public func addToFrames(_ values: NSSet)

    @objc(removeFrames:)
    @NSManaged public func removeFromFrames(_ values: NSSet)

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
