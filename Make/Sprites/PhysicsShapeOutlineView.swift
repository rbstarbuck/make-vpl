//
//  PhysicsShapeOutlineView.swift
//  Make
//
//  Created by Richmond Starbuck on 3/19/17.
//
//

import UIKit


class PhysicsShapeOutlineView: UIView {
    
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
    
}
