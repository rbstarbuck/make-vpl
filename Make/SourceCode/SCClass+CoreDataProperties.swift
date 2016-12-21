//
//  SCClass+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import Foundation
import CoreData


extension SCClass {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCClass> {
        return NSFetchRequest<SCClass>(entityName: "Class");
    }

    @NSManaged public var methods: NSSet?
    @NSManaged public var variables: NSSet?

}

// MARK: Generated accessors for methods
extension SCClass {

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
extension SCClass {

    @objc(addVariablesObject:)
    @NSManaged public func addToVariables(_ value: SCVariable)

    @objc(removeVariablesObject:)
    @NSManaged public func removeFromVariables(_ value: SCVariable)

    @objc(addVariables:)
    @NSManaged public func addToVariables(_ values: NSSet)

    @objc(removeVariables:)
    @NSManaged public func removeFromVariables(_ values: NSSet)

}
