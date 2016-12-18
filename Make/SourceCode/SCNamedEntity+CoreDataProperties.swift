//
//  SCNamedEntity+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


extension SCNamedEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCNamedEntity> {
        return NSFetchRequest<SCNamedEntity>(entityName: "NamedEntity");
    }

    @NSManaged public var comment: String?
    @NSManaged public var name: String?

}
