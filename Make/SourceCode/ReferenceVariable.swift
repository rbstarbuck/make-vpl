//
//  ReferenceVariable.swift
//  Make
//
//  Created by Richmond Starbuck on 1/31/17.
//
//

import UIKit
import SpriteKit
import CoreData


public class ReferenceVariable: NSObject, NSCoding, Variable {
    
    public let sourceId: String
    public let graphicId: String
    
    public var position = CGPoint(x: 0.5, y: 0.5)
    public var scale = 0.1
    public var rotation = 0.0
    
    
    public init(from source: SCSprite) {
        self.sourceId = source.id
        self.graphicId = source.graphic.id
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.sourceId = aDecoder.decodeObject(forKey: "sourceId") as! String
        self.graphicId = aDecoder.decodeObject(forKey: "graphicId") as! String
        self.position = aDecoder.decodeCGPoint(forKey: "position")
        self.scale = aDecoder.decodeDouble(forKey: "scale")
        self.rotation = aDecoder.decodeDouble(forKey: "rotation")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.sourceId, forKey: "sourceId")
        aCoder.encode(self.graphicId, forKey: "graphicId")
        aCoder.encode(self.position, forKey: "position")
        aCoder.encode(self.scale, forKey: "scale")
        aCoder.encode(self.rotation, forKey: "rotation")
    }
    
    
    public func instantiate(in scene: OCScene) {
        if let graphic = scene.world.graphics[self.graphicId] {
            let sprite = SKSpriteNode(texture: graphic.frames.first!)
            sprite.position = CGPoint(x: self.position.x * scene.size.width,
                                      y: self.position.y * scene.size.height)
            sprite.setScale(CGFloat(self.scale))
            sprite.zRotation = CGFloat(self.rotation)
            
            scene.addChild(sprite)
        }
    }
}
