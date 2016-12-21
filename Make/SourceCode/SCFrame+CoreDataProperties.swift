//
//  SCFrame+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import Foundation
import CoreData


extension SCFrame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCFrame> {
        return NSFetchRequest<SCFrame>(entityName: "Frame");
    }

    @NSManaged public var graphic: SCGraphic?
    @NSManaged public var layers: NSOrderedSet?

}

// MARK: Generated accessors for layers
extension SCFrame {

    @objc(insertObject:inLayersAtIndex:)
    @NSManaged public func insertIntoLayers(_ value: SCLayer, at idx: Int)

    @objc(removeObjectFromLayersAtIndex:)
    @NSManaged public func removeFromLayers(at idx: Int)

    @objc(insertLayers:atIndexes:)
    @NSManaged public func insertIntoLayers(_ values: [SCLayer], at indexes: NSIndexSet)

    @objc(removeLayersAtIndexes:)
    @NSManaged public func removeFromLayers(at indexes: NSIndexSet)

    @objc(replaceObjectInLayersAtIndex:withObject:)
    @NSManaged public func replaceLayers(at idx: Int, with value: SCLayer)

    @objc(replaceLayersAtIndexes:withLayers:)
    @NSManaged public func replaceLayers(at indexes: NSIndexSet, with values: [SCLayer])

    @objc(addLayersObject:)
    @NSManaged public func addToLayers(_ value: SCLayer)

    @objc(removeLayersObject:)
    @NSManaged public func removeFromLayers(_ value: SCLayer)

    @objc(addLayers:)
    @NSManaged public func addToLayers(_ values: NSOrderedSet)

    @objc(removeLayers:)
    @NSManaged public func removeFromLayers(_ values: NSOrderedSet)

}
