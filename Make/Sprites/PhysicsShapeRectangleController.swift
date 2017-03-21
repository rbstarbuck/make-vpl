//
//  PhysicsShapeRectangleController.swift
//  Make
//
//  Created by Richmond Starbuck on 3/20/17.
//
//

import UIKit


class PhysicsShapeRectangleController: PhysicsShapeController {
    
    var previousTouch1: CGPoint!
    var previousTouch2: CGPoint!
    
    
    override init(view: PhysicsShapeView, sprite: SCSprite) {
        super.init(view: view, sprite: sprite)
        
        self.configure()
    }
    
    init(view: PhysicsShapeView, previous: PhysicsShapeDelegate) {
        super.init(view: view, sprite: previous.sprite)
        
        let width = view.outlineView.bounds.width / view.graphicImageView.bounds.width
        let height = view.outlineView.bounds.height / view.graphicImageView.bounds.height
        let size = CGSize(width: width, height: height)
        
        let shape = SCPhysicsBodyShapeRectangle(center: self.outlineCenterPct, size: size)
        
        self.sprite.physicsBody.setValue(shape, forKey: "shape")
        self.sprite.world.connector.saveContext()
        
        self.configure()
    }
    
    
    override func setOutlineView() {
        if let view = self.view, let rectangle = self.sprite.physicsBody.shape as? SCPhysicsBodyShapeRectangle {
            let imageOrigin = view.convert(view.graphicImageView.frame.origin, to: view)
            
            let width = rectangle.size.width * view.graphicImageView.bounds.width
            let height = rectangle.size.height * view.graphicImageView.bounds.height
            let centerX = rectangle.center.x * view.graphicImageView.bounds.width
            let centerY = rectangle.center.y * view.graphicImageView.bounds.height
            
            view.outlineView.frame = CGRect(x: imageOrigin.x + centerX - (width / 2.0),
                                            y: imageOrigin.y + centerY - (height / 2.0),
                                            width: width, height: height)
        }
    }
    
    override func pinchBegan(_ sender: UIPinchGestureRecognizer) {
        self.previousTouch1 = sender.location(ofTouch: 0, in: self.view!)
        self.previousTouch2 = sender.location(ofTouch: 1, in: self.view!)
    }
    
    override func pinchChanged(_ sender: UIPinchGestureRecognizer) {
        let touch1 = sender.location(ofTouch: 0, in: self.view!)
        let touch2 = sender.location(ofTouch: 1, in: self.view!)
        let outlineViewPosition = self.view!.outlineView.convert(self.view!.outlineView.bounds.origin, to: self.view!)
        
        let diffX = abs(touch1.x - touch2.x) - abs(self.previousTouch1.x - self.previousTouch2.x)
        let diffY = abs(touch1.y - touch2.y) - abs(self.previousTouch1.y - self.previousTouch2.y)
        
        var width = self.view!.outlineView.width + diffX
        var height = self.view!.outlineView.height + diffY
        var posX = outlineViewPosition.x - (diffX / 2.0)
        var posY = outlineViewPosition.y - (diffY / 2.0)
        
        if width < self.minimumSize || posX < 0 || posX + width > self.view!.bounds.width {
            width = self.view!.outlineView.bounds.width
            posX = outlineViewPosition.x
        }
        else {
            self.previousTouch1.x = touch1.x
            self.previousTouch2.x = touch2.x
        }
        
        if height < self.minimumSize || posY < 0 || posY + height > self.view!.bounds.height {
            height = self.view!.outlineView.bounds.height
            posY = outlineViewPosition.y
        }
        else {
            self.previousTouch1.y = touch1.y
            self.previousTouch2.y = touch2.y
        }
        
        self.view!.outlineView.frame = CGRect(x: posX, y: posY, width: width, height: height)
        self.view!.outlineView.setNeedsDisplay()
    }
    
    override func saveShape() {
        if let view = self.view {
            let width = view.outlineView.bounds.width / view.graphicImageView.bounds.width
            let height = view.outlineView.bounds.height / view.graphicImageView.bounds.height
            
            let graphicOrigin = view.convert(view.graphicImageView.frame.origin, to: view)
            let centerFrame = view.graphicImageView.convert(view.outlineView.center, to: view.graphicImageView)
            let centerX = (centerFrame.x - graphicOrigin.x) / view.graphicImageView.bounds.width
            let centerY = (centerFrame.y - graphicOrigin.y) / view.graphicImageView.bounds.height
            
            let size = CGSize(width: width, height: height)
            let center = CGPoint(x: centerX, y: centerY)
            let shape = SCPhysicsBodyShapeRectangle(center: center, size: size)
            
            self.sprite.physicsBody.setValue(shape, forKey: "shape")
            self.sprite.world.connector.saveContext()
        }
    }
    
    override func drawShape(in view: UIView, with context: CGContext) {
        let rect = CGRect(x: self.halfOutlineWidth,
                          y: self.halfOutlineWidth,
                          width: view.bounds.width - self.outlineWidth,
                          height: view.bounds.height - self.outlineWidth)
        
        context.setLineWidth(self.outlineWidth)
        context.setStrokeColor(self.outlineColor.cgColor)
        context.addRect(rect)
        context.strokePath()
        
        context.setLineDash(phase: 4, lengths: [8.0, 8.0])
        context.setStrokeColor(UIColor.purple.cgColor)
        context.addRect(rect)
        context.strokePath()
    }
    
}
