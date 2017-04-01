//
//  ScenesReferenceView.swift
//  Make
//
//  Created by Richmond Starbuck on 3/22/17.
//
//

import UIKit



class ScenesReferenceView: UIView {
    
    static var outlineColor = UIColor.lightGray
    
    static var outlineWidth = CGFloat(2) {
        didSet {
            self.handleSize = self.outlineWidth * 2.0
            self.halfHandleSize = self.handleSize / 2.0
        }
    }
    
    static var outlineDashLengths = [CGFloat(4), CGFloat(4)]
    
    private static var handleSize = CGFloat(6)
    private static var halfHandleSize = CGFloat(3)

    
    weak var imageView: UIImageView!
    
    var delegate: ScenesPlacementDelegate! {
        didSet {
            self.initialize()
        }
    }
    
    var reference: SCReference! {
        didSet {
            self.initialize()
        }
    }
    
    var isSelected = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    
    override func willMove(toWindow newWindow: UIWindow?) {
        self.backgroundColor = UIColor.clear
        
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.constrainEdgesToParent(self)
        self.imageView = imageView
        
        self.initialize()
    }
    
    
    private func initialize() {
        if self.delegate != nil && self.reference != nil && self.imageView != nil {
            self.update()
        }
    }
    
    func update() {
        self.updateImage()
        self.updateTransform()
    }
    
    func updateImage() {
        self.imageView.image = self.reference.sprite.editorImage
    }
    
    func updateTransform() {
        self.transform = CGAffineTransform.identity
        
        self.frame = self.reference.frame(in: self.delegate.gameplayViewFrame)
        
        let cosA = CGFloat(cos(self.reference.rotation))
        let sinA = CGFloat(sin(self.reference.rotation))
        let flipX = CGFloat(self.reference.flipX ? -1 : 1)
        let flipY = CGFloat(self.reference.flipY ? -1 : 1)
        self.transform = CGAffineTransform(a: cosA * flipX,
                                           b: sinA * flipX,
                                           c: -sinA * flipY,
                                           d: cosA * flipY,
                                           tx: 0, ty: 0)
        
        self.setNeedsDisplay()
    }
    
    
    func contains(gesture: UIGestureRecognizer) -> Bool {
        let location = gesture.location(in: self)
        return self.bounds.contains(location)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.isSelected {
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            
            let lineRect = CGRect(x: ScenesReferenceView.halfHandleSize,
                                  y: ScenesReferenceView.halfHandleSize,
                                  width: self.bounds.width - ScenesReferenceView.handleSize,
                                  height: self.bounds.height - ScenesReferenceView.handleSize)
            
            context.setLineWidth(ScenesReferenceView.outlineWidth)
            context.setStrokeColor(ScenesReferenceView.outlineColor.cgColor)
            context.setLineDash(phase: 0, lengths: ScenesReferenceView.outlineDashLengths)
            context.addRect(lineRect)
            context.strokePath()
            
            
            context.setFillColor(ScenesReferenceView.outlineColor.cgColor)
            let x1 = self.bounds.width / 2.0 - ScenesReferenceView.halfHandleSize
            let x2 = self.bounds.width - ScenesReferenceView.handleSize
            let y1 = self.bounds.height / 2.0 - ScenesReferenceView.halfHandleSize
            let y2 = self.bounds.height - ScenesReferenceView.handleSize
            
            var handleRect = CGRect(x: 0, y: 0,
                                    width: ScenesReferenceView.handleSize,
                                    height: ScenesReferenceView.handleSize)
            context.fill(handleRect)
            
            handleRect.origin.x = x1
            context.fill(handleRect)
            
            handleRect.origin.x = x2
            context.fill(handleRect)
            
            handleRect.origin.y = y1
            context.fill(handleRect)
            
            handleRect.origin.x = 0
            context.fill(handleRect)
            
            handleRect.origin.y = y2
            context.fill(handleRect)
            
            handleRect.origin.x = x1
            context.fill(handleRect)
            
            handleRect.origin.x = x2
            context.fill(handleRect)
            
        }
    }
    
}
