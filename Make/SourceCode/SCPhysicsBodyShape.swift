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
public protocol SCPhysicsBodyShape: NSCoding {
    
    func instantiate(for sprite: SKSpriteNode) -> SKPhysicsBody
    
}

public class SCPhysicsBodyShapeRectangle: NSObject, SCPhysicsBodyShape {
    
    public var size = CGSize(width: 0.8, height: 0.8)
    public var center = CGPoint(x: 0.5, y: 0.5)
    
    
    public override init() {
        super.init()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init()
        self.size = aDecoder.decodeCGSize(forKey: "size")
        self.center = aDecoder.decodeCGPoint(forKey: "center")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.size, forKey: "size")
        aCoder.encode(self.center, forKey: "center")
    }
    
    
    public func instantiate(for sprite: SKSpriteNode) -> SKPhysicsBody {
        let size = CGSize(width: self.size.width * sprite.size.width, height: self.size.height * sprite.size.height)
        return SKPhysicsBody(rectangleOf: size, center: center)
    }
    
}
