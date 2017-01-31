//
//  PhysicsPropertiesController.swift
//  Make
//
//  Created by Richmond Starbuck on 1/19/17.
//
//

import Foundation


protocol PhysicsPropertiesDelegate {
    
    var isDynamic: Bool { get set }
    var isAffectedByGravity: Bool { get set }
    var canRotate: Bool { get set }
    var density: Double { get set }
    var friction: Double { get set }
    var restitution: Double { get set }
    var linearDamping: Double { get set }
    var angularDamping: Double { get set }
    
}


class PhysicsPropertiesController: PhysicsPropertiesDelegate {
    
    var physicsBody: SCPhysicsBody
    
    var world: SCWorld {
        get {
            return self.physicsBody.sprite.world
        }
    }
    
    var isDynamic: Bool {
        get {
            return self.physicsBody.isDynamic
        }
        set {
            self.physicsBody.isDynamic = newValue
            self.world.connector.saveContext()
        }
    }
    
    var isAffectedByGravity: Bool {
        get {
            return self.physicsBody.isAffectedByGravity
        }
        set {
            self.physicsBody.isAffectedByGravity = newValue
            self.world.connector.saveContext()
        }
    }
    
    var canRotate: Bool {
        get {
            return self.physicsBody.canRotate
        }
        set {
            self.physicsBody.canRotate = newValue
            self.world.connector.saveContext()
        }
    }
    
    var density: Double {
        get {
            return self.physicsBody.density
        }
        set {
            self.physicsBody.density = newValue
            self.world.connector.saveContext()
        }
    }
    
    var friction: Double {
        get {
            return self.physicsBody.friction
        }
        set {
            self.physicsBody.friction = newValue
            self.world.connector.saveContext()
        }
    }
    
    var restitution: Double {
        get {
            return self.physicsBody.restitution
        }
        set {
            self.physicsBody.restitution = newValue
            self.world.connector.saveContext()
        }
    }
    
    var linearDamping: Double {
        get {
            return self.physicsBody.linearDamping
        }
        set {
            self.physicsBody.linearDamping = newValue
            self.world.connector.saveContext()
        }
    }
    
    var angularDamping: Double {
        get {
            return self.physicsBody.angularDamping
        }
        set {
            self.physicsBody.angularDamping = newValue
            self.world.connector.saveContext()
        }
    }
    
    
    init(view: PhysicsPropertiesView, physicsBody: SCPhysicsBody) {
        self.physicsBody = physicsBody
        view.delegate = self
    }
    
}
