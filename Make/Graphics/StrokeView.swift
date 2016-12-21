//
//  StrokeView.swift
//  Make
//
//  Created by Richmond Starbuck on 12/19/16.
//
//

import UIKit


class StrokeView: UIImageView {
    var delegate: StrokeDelegate! {
        didSet {
            // enable touch events when valid delegate becomes available
            self.isUserInteractionEnabled = (delegate != nil)
        }
    }
    
    var lastPoint = CGPoint()
    var swiped = false
    
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        // to ensure delegate is non-nil in touch events
        self.isUserInteractionEnabled = (delegate != nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            drawLineFrom(from: lastPoint, to: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // draw a single point if touch wasn't dragged
        if !swiped {
            drawLineFrom(from: lastPoint, to: lastPoint)
        }
        
        if let image = self.image {
            delegate.drawToCanvas(image)
            self.image = nil
        }
    }
    
    private func drawLineFrom(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.frame.size)
        
        if let context = UIGraphicsGetCurrentContext() {
            let frameRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            self.image?.draw(in: frameRect)
            
            context.move(to: fromPoint)
            context.addLine(to: toPoint)
            
            context.setLineCap(.round)
            context.setLineWidth(delegate.brushWidth)
            context.setStrokeColor(delegate.color.cgColor)
            context.setBlendMode(.normal)
            
            context.strokePath()
            
            self.image = UIGraphicsGetImageFromCurrentImageContext()
            self.alpha = delegate.opacity
        }
        
        UIGraphicsEndImageContext()
    }
    
}
