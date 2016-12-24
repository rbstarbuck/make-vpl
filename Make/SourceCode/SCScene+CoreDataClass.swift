//
//  SCScene+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


public class SCScene: NSManagedObject {
    public static let entityName = "Scene"

    
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var methods: Set<SCMethod>
    @NSManaged public var variables: Set<SCVariable>
    @NSManaged public var world: SCWorld
    
    
    override public func awakeFromInsert() {
        self.id = UUID().uuidString
        self.methods = Set<SCMethod>()
        self.variables = Set<SCVariable>()
    }
    
    @discardableResult
    public func createMethod() -> SCMethod {
        let method: SCMethod = self.world.connector.createEntity(SCMethod.entityName)!
        method.name = "\(SCConstants.METHOD_DISPLAY_TITLE) \(self.methods.count + 1)"
        self.addToMethods(method)
        return method
    }
    
    @discardableResult
    public func createVariable() -> SCVariable {
        let variable: SCVariable = self.world.connector.createEntity(SCVariable.entityName)!
        variable.name = "\(SCConstants.VARIABLE_DISPLAY_TITLE) \(self.variables.count + 1)"
        self.addToVariables(variable)
        return variable
    }
    
}
