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
    
    var layerSubviews = [SCLayer: UIImageView]()
    
    
    override func willMove(toWindow newWindow: UIWindow?) {
        self.isMultipleTouchEnabled = false
        self.isUserInteractionEnabled = (self.delegate != nil)
    }
    
        
    // MARK: - Layer handling
    
    func insertLayer(_ layer: SCLayer) {
        let imageView = layer.makeImageView()
        self.layerSubviews[layer] = imageView
        self.addSubview(imageView)
        imageView.constrainEdgesToParent(self)
    }
    
    func insertInkingSurface(_ inkingSurface: UIImageView, above layer: SCLayer) {
        if let layerSubview = self.layerSubviews[layer] {
            inkingSurface.removeFromSuperview()
            self.insertSubview(inkingSurface, aboveSubview: layerSubview)
            inkingSurface.constrainEdgesToParent(self)
        }
    }
    
    @discardableResult
    func removeLayer(_ layer: SCLayer) -> Bool {
        if let subview = self.layerSubviews.removeValue(forKey: layer) {
            subview.removeFromSuperview()
            return true
        }
        return false
    }
    
    func removeAllLayers() {
        for pair in self.layerSubviews {
            self.removeLayer(pair.key)
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
