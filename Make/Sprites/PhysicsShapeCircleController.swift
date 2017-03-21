//
//  PhysicsShapeCircleController.swift
//  Make
//
//  Created by Richmond Starbuck on 3/20/17.
//
//

import UIKit


class PhysicsShapeCircleController: PhysicsShapeController {
        
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
    
    override func pinchChanged(_ sender: UIPinchGestureRecognizer) {
        let outlineViewPosition = self.view!.outlineView.convert(self.view!.outlineView.bounds.origin, to: self.view!)
        
        let size = sender.scale * self.view!.outlineView.width
        let translation = (size - self.view!.outlineView.width) / 2.0
        
        let posX = outlineViewPosition.x - translation
        let posY = outlineViewPosition.y - translation
        
        if size >= self.minimumSize && posX >= 0 && posX + size <= self.view!.bounds.width
                && posY >= 0 && posY + size <= self.view!.bounds.height {
            self.view!.outlineView.frame = CGRect(x: posX, y: posY, width: size, height: size)
            self.view!.outlineView.setNeedsDisplay()
            sender.scale = 1
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
