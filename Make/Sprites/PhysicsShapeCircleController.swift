//
//  PhysicsShapeCircleController.swift
//  Make
//
//  Created by Richmond Starbuck on 3/20/17.
//
//

import UIKit


class PhysicsShapeCircleController: PhysicsShapeController {
    
    var previousTouch1: CGPoint!
    var previousTouch2: CGPoint!
    
    
    override init(view: PhysicsShapeView, sprite: SCSprite) {
        super.init(view: view, sprite: sprite)
        
        self.configure()
    }
    
    init(view: PhysicsShapeView, previous: PhysicsShapeDelegate) {
        super.init(view: view, sprite: previous.sprite)
        
        let outlineViewSize = min(view.outlineView.bounds.width, view.outlineView.bounds.height)
        let radius = outlineViewSize / view.graphicImageView.bounds.width / 2.0
        
        let shape = SCPhysicsBodyShapeCircle(center: self.outlineCenterPct, radius: Double(radius))
        
        self.sprite.physicsBody.setValue(shape, forKey: "shape")
        self.sprite.world.connector.saveContext()
        
        self.configure()
    }
    
    
    override func setOutlineView() {
        if let view = self.view, let circle = self.sprite.physicsBody.shape as? SCPhysicsBodyShapeCircle {
            let imageOrigin = view.convert(view.graphicImageView.frame.origin, to: view)
            
            let radius = CGFloat(circle.radius) * view.graphicImageView.bounds.width
            let centerX = circle.center.x * view.graphicImageView.bounds.width
            let centerY = circle.center.y * view.graphicImageView.bounds.height
            
            view.outlineView.frame = CGRect(x: imageOrigin.x + centerX - radius,
                                            y: imageOrigin.y + centerY - radius,
                                            width: radius * 2, height: radius * 2)
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
        
        let prevDistance = self.previousTouch1.distance(to: self.previousTouch2)
        let currDistance = touch1.distance(to: touch2)
        
        let diff = currDistance - prevDistance
        let size = self.view!.outlineView.width + diff
        let translation = (size - self.view!.outlineView.width) / 2.0
        let posX = outlineViewPosition.x - translation
        let posY = outlineViewPosition.y - translation
        
        if size >= self.minimumSize && posX >= 0 && posX + size <= self.view!.bounds.width
                && posY >= 0 && posY + size <= self.view!.bounds.height {
            self.view!.outlineView.frame = CGRect(x: posX, y: posY, width: size, height: size)
            self.view!.outlineView.setNeedsDisplay()
            self.previousTouch1 = touch1
            self.previousTouch2 = touch2
        }
    }
    
    override func saveShape() {
        if let view = self.view {
            let graphicOrigin = view.convert(view.graphicImageView.frame.origin, to: view)
            let centerFrame = view.graphicImageView.convert(view.outlineView.center, to: view.graphicImageView)
            let centerX = (centerFrame.x - graphicOrigin.x) / view.graphicImageView.bounds.width
            let centerY = (centerFrame.y - graphicOrigin.y) / view.graphicImageView.bounds.height
            
            let radius = Double(view.outlineView.bounds.width / view.graphicImageView.bounds.width / 2.0)
            let center = CGPoint(x: centerX, y: centerY)
            let shape = SCPhysicsBodyShapeCircle(center: center, radius: radius)
            
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
        context.addEllipse(in: rect)
        context.strokePath()
        
        context.setLineDash(phase: 4, lengths: [8.0, 8.0])
        context.setStrokeColor(UIColor.red.cgColor)
        context.addEllipse(in: rect)
        context.strokePath()
    }
    
}
