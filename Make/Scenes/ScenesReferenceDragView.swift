//
//  ScenesReferenceDragView.swift
//  Make
//
//  Created by Richmond Starbuck on 3/22/17.
//
//

import UIKit


private let frameChangeAnimationDuration = 0.5
private let imageViewAlpha: CGFloat = 0.75


class ScenesReferenceDragView: UIView {

    var sprite: SCSprite! {
        didSet {
            self.setImage()
        }
    }
    
    private var hasSetImage = false
    
    
    override func willMove(toWindow newWindow: UIWindow?) {
        self.backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.sprite != nil {
            self.setImage()
        }
    }
    
    // TODO: move to supercontroller
    private func setImage() {
        if !self.hasSetImage {
            var image: UIImage!
            var scale: CGFloat = 1.0
            
            if let graphic = sprite.graphic {
                image = graphic.firstFrame.makeImageFromLayers()
                scale = CGFloat(SCReference.defaultScale)
            }
            else {
                image = UIImage(named: "Placeholder image")
            }
            
            let imageView = UIImageView(image: image)
            imageView.alpha = imageViewAlpha
            self.addSubview(imageView)
            imageView.constrainEdgesToParent(self)
            
            let width = image.size.width * scale
            let transformScale = width / self.bounds.width
            
            UIView.animate(withDuration: frameChangeAnimationDuration) {
                self.transform = CGAffineTransform(scaleX: transformScale, y: transformScale)
            }
            
            self.hasSetImage = true
        }
    }
    
}
