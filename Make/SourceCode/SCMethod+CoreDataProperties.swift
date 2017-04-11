//
//  SCMethod+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/23/16.
//
//

import Foundation
import CoreData


extension SCMethod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCMethod> {
        return NSFetchRequest<SCMethod>(entityName: "Method");
    }

}
