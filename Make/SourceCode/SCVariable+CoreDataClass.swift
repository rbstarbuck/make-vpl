//
//  SCVariable+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


public class SCVariable: NSManagedObject, SCNamedEntity {
    public static let entityName = "Variable"

    
    @NSManaged public var id: String
    @NSManaged public var data: SCVariableData
    @NSManaged public var name: String
    
    
    
    public override func awakeFromInsert() {
        self.id = UUID().uuidString
    }
    
}
