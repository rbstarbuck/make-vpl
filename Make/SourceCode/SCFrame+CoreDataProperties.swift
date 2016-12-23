//
//  SCFrame+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/21/16.
//
//

import Foundation
import CoreData


extension SCFrame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCFrame> {
        return NSFetchRequest<SCFrame>(entityName: "Frame");
    }


}

// MARK: Generated accessors for layers
extension SCFrame {

    @objc(addLayersObject:)
    @NSManaged public func addToLayers(_ value: SCLayer)

    @objc(removeLayersObject:)
    @NSManaged public func removeFromLayers(_ value: SCLayer)

    @objc(addLayers:)
    @NSManaged public func addToLayers(_ values: NSSet)

    @objc(removeLayers:)
    @NSManaged public func removeFromLayers(_ values: NSSet)

}
