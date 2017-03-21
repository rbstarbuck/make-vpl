//
//  PhysicsShapeOutlineView.swift
//  Make
//
//  Created by Richmond Starbuck on 3/19/17.
//
//

import UIKit


class PhysicsShapeOutlineView: UIView {
    
    var outlineColor = UIColor.green
    var minimumSize = CGFloat(20)
    var outlineWidth = CGFloat(3) {
        didSet {
            self.halfOutlineWidth = self.outlineWidth / 2.0
        }
    }
    private var halfOutlineWidth = CGFloat(1.5)
    
    var delegate: PhysicsShapeDelegate? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let context = UIGraphicsGetCurrentContext() {
            self.delegate?.drawShape(in: self, with: context)
        }
    }
    
    func drawRectangle(context: CGContext) {
        let rect = CGRect(x: self.halfOutlineWidth,
                          y: self.halfOutlineWidth,
                          width: self.bounds.width - self.outlineWidth,
                          height: self.bounds.height - self.outlineWidth)
        
        context.setLineWidth(self.outlineWidth)
        context.setStrokeColor(self.outlineColor.cgColor)
        context.addRect(rect)
        
        context.strokePath()
    }
    
}
