//
//  OCGraphic.swift
//  Make
//
//  Created by Richmond Starbuck on 1/14/17.
//
//

import UIKit
import SpriteKit


class OCGraphic {
    
    let source: SCGraphic
    
    var frames = [SKTexture]()
    
    var timePerFrame: Double
    
    
    init(from source: SCGraphic) {
        self.source = source
        self.timePerFrame = 1.0 / source.animationFPS
        
        let graphic = source.makeGraphicFromFrames()
        let numFrames = graphic.count
        var textureAtlasDict = [String: UIImage](minimumCapacity: graphic.count)
        for index in 0..<numFrames {
            textureAtlasDict["\(index)"] = graphic[index]
        }
        
        let textureAtlas = SKTextureAtlas(dictionary: textureAtlasDict)
        
        self.frames.reserveCapacity(numFrames)
        for index in 0..<numFrames {
            let texture = textureAtlas.textureNamed("\(index)")
            self.frames.append(texture)
        }
    }
    
}
