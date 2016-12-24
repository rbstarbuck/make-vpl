//
//  SCSprite+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/23/16.
//
//

import Foundation
import CoreData


extension SCSprite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCSprite> {
        return NSFetchRequest<SCSprite>(entityName: "Sprite");
    }

    @NSManaged public var comment: String?
    @NSManaged public var graphic: SCGraphic?

}

// MARK: Generated accessors for methods
extension SCSprite {

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
extension SCSprite {

    @objc(addVariablesObject:)
    @NSManaged public func addToVariables(_ value: SCVariable)

    @objc(removeVariablesObject:)
    @NSManaged public func removeFromVariables(_ value: SCVariable)

    @objc(addVariables:)
    @NSManaged public func addToVariables(_ values: NSSet)

    @objc(removeVariables:)
    @NSManaged public func removeFromVariables(_ values: NSSet)

}
