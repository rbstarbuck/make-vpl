//
//  SCIndexedEntity+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/23/16.
//
//

import Foundation
import CoreData


extension SCIndexedEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCIndexedEntity> {
        return NSFetchRequest<SCIndexedEntity>(entityName: "IndexedEntity");
    }

}
