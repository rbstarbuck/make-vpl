//
//  SCSprite+CoreDataProperties.swift
//  
//
//  Created by Richmond Starbuck on 3/23/17.
//
//

import Foundation
import CoreData


extension SCSprite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCSprite> {
        return NSFetchRequest<SCSprite>(entityName: "Sprite");
    }

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

// MARK: Generated accessors for references
extension SCSprite {

    @objc(addReferencesObject:)
    @NSManaged public func addToReferences(_ value: SCReference)

    @objc(removeReferencesObject:)
    @NSManaged public func removeFromReferences(_ value: SCReference)

    @objc(addReferences:)
    @NSManaged public func addToReferences(_ values: NSSet)

    @objc(removeReferences:)
    @NSManaged public func removeFromReferences(_ values: NSSet)

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
