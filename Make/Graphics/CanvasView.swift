//
//  CanvasView.swift
//  Make
//
//  Created by Richmond Starbuck on 12/27/16.
//
//

import UIKit

class CanvasView: UIView {
    
    var delegate: CanvasDelegate? {
        didSet {
            self.isUserInteractionEnabled = (self.delegate != nil)
        }
    }
    
    var lastPoint = CGPoint()
    var swiped = false
    
    
    override func willMove(toWindow newWindow: UIWindow?) {
        self.isMultipleTouchEnabled = false
        self.isUserInteractionEnabled = (self.delegate != nil)
    }
    
        
    // MARK: - Layer handling
    
    func insertLayer(_ layer: SCLayer) {
        let imageView = layer.makeImageView()
        self.insertView(imageView)
    }
    
    func insertView(_ view: UIImageView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.constrainEdgesToParent(self)
        
    }
    
    @discardableResult
    func removeLayer(_ layer: SCLayer) -> Bool {
        for view in self.subviews {
            if view.layer.zPosition == CGFloat(layer.index) {
                view.removeFromSuperview()
                return true
            }
        }
        return false
    }
    
    func removeAllLayers() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    
    // MARK: - Touch handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate!.beginDrawing()
        
        self.swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            self.delegate!.drawLine(from: lastPoint, to: currentPoint)
            self.lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // draw a single point if touch wasn't dragged
        if !self.swiped {
            self.delegate!.drawPoint(at: lastPoint)
        }
        
        self.delegate!.commitDrawing()
    }
    
}
