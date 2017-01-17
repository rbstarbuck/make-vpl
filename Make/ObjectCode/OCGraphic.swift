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
    
    //var textureAtlas: SKTextureAtlas
    
    var frames = [SKTexture]()
    
    var timePerFrame: Double
    
    
    init(from source: SCGraphic) {
        self.source = source
        self.timePerFrame = 1.0 / source.animationFPS
        
        var textureAtlasDict = [String: UIImage]()
        let sortedFrames = self.source.sortedFrames
        let numFrames = sortedFrames.count
        for index in 0..<numFrames {
            let imageView = sortedFrames[index].makeImageView()
            textureAtlasDict["\(index)"] = imageView.image!
        }
        let textureAtlas = SKTextureAtlas(dictionary: textureAtlasDict)
        
        self.frames.reserveCapacity(numFrames)
        for index in 0..<numFrames {
            let texture = textureAtlas.textureNamed("\(index)")
            self.frames.append(texture)
        }
    }
    
}
