//
//  OCSprite.swift
//  Make
//
//  Created by Richmond Starbuck on 2/24/17.
//
//

import Foundation
import CoreData
import SpriteKit


public class OCSprite: SKSpriteNode {
    
    public var variables: Variables
    
    public var id: String {
        get {
            return self.name!
        }
    }
    
    
    public init(from scReference: SCReference, in ocScene: OCScene) {
        self.variables = Variables(parent: ocScene.variables)
        
        let request = NSFetchRequest<SCSprite>(entityName: SCSprite.entityName)
        request.predicate = NSPredicate(format: "id == %@", scReference.sprite.id)
        let scSprite = ocScene.world.connector.fetchEntities(request)!.first!
        
        var texture: SKTexture!
        if let scGraphic = scSprite.graphic {
            let ocGraphic = ocScene.world.graphics[scGraphic.id]!
            texture = ocGraphic.frames.first!
        }
        else {
            texture = SKTexture(imageNamed: "Placeholder image")
        }
        
        super.init(texture: texture, color: UIColor.red, size: texture.size())
        
        self.name = scReference.id
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = scReference.center(in: ocScene.frame)
        self.setScale(scReference.scale(in: ocScene.size))
        self.zRotation = CGFloat(scReference.rotation)
        
        if scSprite.physicsBody.isEnabled {
            self.physicsBody = self.makePhysicsBody(from: scSprite.physicsBody)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.variables = aDecoder.decodeObject(forKey: "variables") as! Variables
        super.init(coder: aDecoder)
    }
    
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.variables, forKey: "variables")
        super.encode(with: aCoder)
    }
    
    
    public func makePhysicsBody(from scPhysicsBody: SCPhysicsBody) -> SKPhysicsBody {
        let physicsBody = scPhysicsBody.shape.instantiate(for: self)
        
        physicsBody.isDynamic = scPhysicsBody.isDynamic
        physicsBody.affectedByGravity = scPhysicsBody.isAffectedByGravity
        physicsBody.allowsRotation = scPhysicsBody.canRotate
        physicsBody.density = CGFloat(scPhysicsBody.density)
        physicsBody.friction = CGFloat(scPhysicsBody.friction)
        physicsBody.restitution = CGFloat(scPhysicsBody.restitution)
        physicsBody.linearDamping = CGFloat(scPhysicsBody.linearDamping)
        physicsBody.angularDamping = CGFloat(scPhysicsBody.angularDamping)
        
        return physicsBody
    }
}
