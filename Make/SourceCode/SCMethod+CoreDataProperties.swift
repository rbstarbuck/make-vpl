//
//  SCMethod+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import Foundation
import CoreData


extension SCMethod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCMethod> {
        return NSFetchRequest<SCMethod>(entityName: "Method");
    }

    @NSManaged public var code: SCBlock?
    @NSManaged public var definition: SCClass?

}
