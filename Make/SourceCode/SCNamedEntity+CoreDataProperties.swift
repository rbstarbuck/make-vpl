//
//  SCNamedEntity+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/23/16.
//
//

import Foundation
import CoreData


extension SCNamedEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCNamedEntity> {
        return NSFetchRequest<SCNamedEntity>(entityName: "NamedEntity");
    }

}
