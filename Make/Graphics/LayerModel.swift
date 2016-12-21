//
//  LayerModel.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import UIKit


class LayerModel: NSCoding {
    var layers: [UIImageView]
    
    init() {
        self.layers = [UIImageView()]
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let layerImages = aDecoder.decodeObject(forKey: "layers") as? [UIImage] {
            layers = [UIImageView]()
            layers.reserveCapacity(layerImages.count)
            for index in 0..<layerImages.count {
                let layer = UIImageView(image: layerImages[index])
                layers.append(layer)
            }
            if layers.count < 1 {
                layers.append(UIImageView())
            }
        }
        else {
            layers = [UIImageView()]
        }
    }
    
    func encode(with aCoder: NSCoder) {
        var layerImages = [UIImage]()
        layerImages.reserveCapacity(layers.count)
        for layer in layers {
            if let image = layer.image {
                layerImages.append(image)
            }
        }
        aCoder.encode(layerImages, forKey: "layers")
    }
}
