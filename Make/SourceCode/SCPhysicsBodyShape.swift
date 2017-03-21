//
//  SCPhysicsBodyShape.swift
//  Make
//
//  Created by Richmond Starbuck on 1/18/17.
//
//

import UIKit
import SpriteKit


@objc
public enum PhysicsShape: Int32 {
    case rectangle, circle
}


@objc
public protocol SCPhysicsBodyShape: NSCoding {
    
    var type: PhysicsShape { get }
    
    func instantiate(for sprite: SKSpriteNode) -> SKPhysicsBody
    
}
