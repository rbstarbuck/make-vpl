//
//  LayerController.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import UIKit
import QuartzCore


class LayerController: LayerDelegate {
    var model: LayerModel
    
    var currentLayer: UIImageView
    
    var inkingLayer: UIImageView
    
    
    init(model: LayerModel) {
        self.model = model
        self.currentLayer = model.layers.last!
        self.inkingLayer = UIImageView()
    }
}
