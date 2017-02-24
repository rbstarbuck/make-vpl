//
//  SCPhysicsBodyShape.swift
//  Make
//
//  Created by Richmond Starbuck on 1/18/17.
//
//

import UIKit
import SpriteKit


@objc(SCPhysicsBodyShape)
public protocol SCPhysicsBodyShape: NSCoding {
    
    init()
    func instantiate(for sprite: SKSpriteNode) -> SKPhysicsBody
    
}

public class SCPhysicsBodyShapeRectangle: NSObject, SCPhysicsBodyShape {
    
    public var size = CGSize(width: 0.8, height: 0.8)
    public var center = CGPoint(x: 0.5, y: 0.5)
    
    
    public override required init() {
        super.init()
    }
    
    public required init(coder aDecoder: NSCoder) {
        
    }
    
    public func encode(with aCoder: NSCoder) {
        
    }
    
    
    public func instantiate(for sprite: SKSpriteNode) -> SKPhysicsBody {
        let size = CGSize(width: self.size.width * sprite.size.width, height: self.size.height * sprite.size.height)
        return SKPhysicsBody(rectangleOf: size, center: center)
    }
    
}
