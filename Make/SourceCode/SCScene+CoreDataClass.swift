//
//  SCScene+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import UIKit
import CoreData


public class SCScene: NSManagedObject, SCNamedEntity, SCGravityEntity {
    public static let entityName = "Scene"
    public static let thumbnailSize = CGSize(width: 120, height: 90)

    
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var gravityMagnitude: Double
    @NSManaged public var gravityDirection: GravityDirection
    @NSManaged public var dateCreated: Date
    @NSManaged public var thumbnail: UIImage
    @NSManaged public var methods: Set<SCMethod>
    @NSManaged public var references: Set<SCReference>
    @NSManaged public var variables: Set<SCVariable>
    @NSManaged public var world: SCWorld
    
    
    override public func awakeFromInsert() {
        self.id = UUID().uuidString
        self.dateCreated = Date()
        self.thumbnail = UIImage()
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
    
    @discardableResult
    public func createReference(to sprite: SCSprite) -> SCReference {
        let reference: SCReference = self.world.connector.createEntity(SCReference.entityName)!
        sprite.addToReferences(reference)
        self.addToReferences(reference)
        return reference
    }
    
}
