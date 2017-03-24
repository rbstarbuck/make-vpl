//
//  ScenesReferenceView.swift
//  Make
//
//  Created by Richmond Starbuck on 3/22/17.
//
//

import UIKit


class ScenesReferenceView: UIView {

    weak var imageView: UIImageView!
    
    
    var delegate: ScenesPlacementDelegate! {
        didSet {
            if self.reference != nil && self.imageView != nil {
                self.update()
            }
        }
    }
    
    var reference: SCReference! {
        didSet {
            if self.delegate != nil && self.imageView != nil {
                self.update()
            }
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
        
        if self.delegate != nil && self.reference != nil {
            self.update()
        }
    }
    
    
    func update() {
        self.updateImage()
        self.updateTransform()
        self.updatePosition()
    }
    
    func updateImage() {
        self.imageView.image = self.reference.sprite.editorImage
    }
    
    func updateTransform() {
        self.frame = self.reference.frame(in: self.delegate.gameplayViewFrame)
        /*let scale = self.reference.scale(in: self.delegate.gameplayViewSize)
        self.transform = CGAffineTransform.identity
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
        self.transform = CGAffineTransform(rotationAngle: CGFloat(self.reference.rotation))*/
    }
    
    func updatePosition() {
        /*let gameplayViewSize = self.delegate.gameplayViewSize
        self.center = CGPoint(x: CGFloat(self.reference.centerX) * gameplayViewSize.width,
                              y: CGFloat(self.reference.centerY) * gameplayViewSize.height)*/
    }
    
}
