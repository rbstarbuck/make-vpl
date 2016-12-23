//
//  SCVariable+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


public class SCVariable: SCNamedEntity {
    override public class func entityName() -> String {
        return "Variable"
    }
}
