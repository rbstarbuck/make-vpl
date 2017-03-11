//
//  SpritesParametersController.swift
//  Make
//
//  Created by Richmond Starbuck on 3/11/17.
//
//

import UIKit


protocol SpritesParametersDelegate: class {
    
}


class SpritesParametersController: SpritesParametersDelegate {
    
    weak var view: SpritesParametersView?
    
    var sprite: SCSprite
    
    
    init(view: SpritesParametersView, sprite: SCSprite) {
        self.view = view
        self.sprite = sprite
        
        view.delegate = self
    }
}
