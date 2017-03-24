//
//  PhysicsShapeController.swift
//  Make
//
//  Created by Richmond Starbuck on 3/19/17.
//
//

import UIKit


protocol PhysicsShapeDelegate: class {
    
    var sprite: SCSprite { get }
    var outlineWidth: CGFloat { get }
    var outlineColor: UIColor { get }
    var minimumSize: CGFloat { get }
    
    var delegate: PhysicsDelegate? { get set }
    
    func configure()
    func setOutlineView()
    func changeShape(_ type: PhysicsShape)
    func saveShape()
    func drawShape(in view: UIView, with context: CGContext)
    
    func panBegan(_ sender: UIPanGestureRecognizer)
    func panChanged(_ sender: UIPanGestureRecognizer)
    func panEnded(_ sender: UIPanGestureRecognizer)
    
    func pinchBegan(_ sender: UIPinchGestureRecognizer)
    func pinchChanged(_ sender: UIPinchGestureRecognizer)
    func pinchEnded(_ sender: UIPinchGestureRecognizer)
    
}


class PhysicsShapeController: PhysicsShapeDelegate {
    
    weak var view: PhysicsShapeView?
    var sprite: SCSprite
    
    var minimumSize = CGFloat(20.0)
    var outlineColor = UIColor.green
    var outlineWidth = CGFloat(3.0) {
        didSet {
            self.halfOutlineWidth = self.outlineWidth / 2.0
        }
    }
    var halfOutlineWidth = CGFloat(1.5)
    
    var delegate: PhysicsDelegate?
    
    var outlineCenterPct: CGPoint {
        get {
            if let view = self.view {
                let outlineCenter = view.convert(view.outlineView.center, to: view)
                let graphicOrigin = view.convert(view.graphicImageView.frame.origin, to: view)
                let centerX = (outlineCenter.x - graphicOrigin.x) / view.graphicImageView.width
                let centerY = (outlineCenter.y - graphicOrigin.x) / view.graphicImageView.height
                return CGPoint(x: centerX, y: centerY)
            }
            else {
                return CGPoint()
            }
        }
    }
    
    
    init(view: PhysicsShapeView, sprite: SCSprite) {
        self.view = view
        self.sprite = sprite
    }
    
    
    func configure() {
        self.view?.delegate = self
        self.view?.configure()
        self.setOutlineView()
    }
    
    func setOutlineView() { }
    func saveShape() { }
    func drawShape(in view: UIView, with context: CGContext) { }
    
    func changeShape(_ type: PhysicsShape){
        self.delegate?.setShape(type)
    }
    
    func panBegan(_ sender: UIPanGestureRecognizer) { }
    
    func panChanged(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view!)
        let outlineViewPosition = self.view!.outlineView.convert(self.view!.outlineView.bounds.origin, to: self.view!)
        
        let newX = translation.x + outlineViewPosition.x
        let newY = translation.y + outlineViewPosition.y
        
        var nextTranslation = CGPoint(x: translation.x, y: translation.y)
        
        if newX >= 0 && newX + self.view!.outlineView.width <= self.view!.width {
            self.view!.outlineView.position.x += translation.x
            nextTranslation.x = 0
        }
        
        if newY >= 0 && newY + self.view!.outlineView.height <= self.view!.height {
            self.view!.outlineView.position.y += translation.y
            nextTranslation.y = 0
        }
        
        sender.setTranslation(nextTranslation, in: self.view!)
    }
    
    func panEnded(_ sender: UIPanGestureRecognizer) {
        self.saveShape()
    }
    
    
    func pinchBegan(_ sender: UIPinchGestureRecognizer) { }
    func pinchChanged(_ sender: UIPinchGestureRecognizer) { }
    
    func pinchEnded(_ sender: UIPinchGestureRecognizer) {
        self.saveShape()
    }
    
}
