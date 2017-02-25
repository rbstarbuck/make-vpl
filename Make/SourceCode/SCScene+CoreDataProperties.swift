//
//  SCScene+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 2/25/17.
//
//

import Foundation
import CoreData


extension SCScene {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCScene> {
        return NSFetchRequest<SCScene>(entityName: "Scene");
    }

    @NSManaged public var comment: String?

}

// MARK: Generated accessors for methods
extension SCScene {

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
extension SCScene {

    @objc(addVariablesObject:)
    @NSManaged public func addToVariables(_ value: SCVariable)

    @objc(removeVariablesObject:)
    @NSManaged public func removeFromVariables(_ value: SCVariable)

    @objc(addVariables:)
    @NSManaged public func addToVariables(_ values: NSSet)

    @objc(removeVariables:)
    @NSManaged public func removeFromVariables(_ values: NSSet)

}

// MARK: Generated accessors for references
extension SCScene {

    @objc(addReferencesObject:)
    @NSManaged public func addToReferences(_ value: SCReference)

    @objc(removeReferencesObject:)
    @NSManaged public func removeFromReferences(_ value: SCReference)

    @objc(addReferences:)
    @NSManaged public func addToReferences(_ values: NSSet)

    @objc(removeReferences:)
    @NSManaged public func removeFromReferences(_ values: NSSet)

}
