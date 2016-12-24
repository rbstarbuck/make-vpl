//
//  SCWorld+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/23/16.
//
//

import Foundation
import CoreData


extension SCWorld {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCWorld> {
        return NSFetchRequest<SCWorld>(entityName: "World");
    }

    @NSManaged public var comment: String?

}

// MARK: Generated accessors for graphics
extension SCWorld {

    @objc(addGraphicsObject:)
    @NSManaged public func addToGraphics(_ value: SCGraphic)

    @objc(removeGraphicsObject:)
    @NSManaged public func removeFromGraphics(_ value: SCGraphic)

    @objc(addGraphics:)
    @NSManaged public func addToGraphics(_ values: NSSet)

    @objc(removeGraphics:)
    @NSManaged public func removeFromGraphics(_ values: NSSet)

}

// MARK: Generated accessors for scenes
extension SCWorld {

    @objc(addScenesObject:)
    @NSManaged public func addToScenes(_ value: SCScene)

    @objc(removeScenesObject:)
    @NSManaged public func removeFromScenes(_ value: SCScene)

    @objc(addScenes:)
    @NSManaged public func addToScenes(_ values: NSSet)

    @objc(removeScenes:)
    @NSManaged public func removeFromScenes(_ values: NSSet)

}

// MARK: Generated accessors for sprites
extension SCWorld {

    @objc(addSpritesObject:)
    @NSManaged public func addToSprites(_ value: SCSprite)

    @objc(removeSpritesObject:)
    @NSManaged public func removeFromSprites(_ value: SCSprite)

    @objc(addSprites:)
    @NSManaged public func addToSprites(_ values: NSSet)

    @objc(removeSprites:)
    @NSManaged public func removeFromSprites(_ values: NSSet)

}

// MARK: Generated accessors for methods
extension SCWorld {

    @objc(addMethodsObject:)
    @NSManaged public func addToMethods(_ value: SCMethod)

    @objc(removeMethodsObject:)
    @NSManaged public func removeFromMethods(_ value: SCMethod)

    @objc(addMethods:)
    @NSManaged public func addToMethods(_ values: NSSet)

    @objc(removeMethods:)
    @NSManaged public func removeFromMethods(_ values: NSSet)

}

// MARK: Generated accessors for variables
extension SCWorld {

    @objc(addVariablesObject:)
    @NSManaged public func addToVariables(_ value: SCVariable)

    @objc(removeVariablesObject:)
    @NSManaged public func removeFromVariables(_ value: SCVariable)

    @objc(addVariables:)
    @NSManaged public func addToVariables(_ values: NSSet)

    @objc(removeVariables:)
    @NSManaged public func removeFromVariables(_ values: NSSet)

}
