//
//  StrokeController.swift
//  Make
//
//  Created by Richmond Starbuck on 12/19/16.
//
//

import UIKit


class StrokeController: StrokeDelegate {
    var layers: LayerDelegate?
    
    var color: UIColor = .black
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    
    
    func drawToCanvas(_ image: UIImage) {
        if let layers = self.layers {
            UIGraphicsBeginImageContext(layers.currentLayer.frame.size)
            
            let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            layers.currentLayer.image?.draw(in: imageRect, blendMode: .normal, alpha: 1.0)
            image.draw(in: imageRect, blendMode: .normal, alpha: opacity)
            
            if let imageContext = UIGraphicsGetImageFromCurrentImageContext() {
                layers.currentLayer.image = imageContext
            }
            UIGraphicsEndImageContext()
        }
    }
}
