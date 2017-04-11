//
//  SCVariable+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/23/16.
//
//

import Foundation
import CoreData


extension SCVariable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCVariable> {
        return NSFetchRequest<SCVariable>(entityName: "Variable");
    }


}
