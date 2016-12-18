//
//  SCIndexedEntity+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


extension SCIndexedEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCIndexedEntity> {
        return NSFetchRequest<SCIndexedEntity>(entityName: "IndexedEntity");
    }

    @NSManaged public var id: String?

}
