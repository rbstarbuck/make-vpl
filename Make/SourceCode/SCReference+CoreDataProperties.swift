//
//  SCReference+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 2/25/17.
//
//

import Foundation
import CoreData


extension SCReference {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCReference> {
        return NSFetchRequest<SCReference>(entityName: "Reference");
    }


}
