//
//  ColorSelectorController.swift
//  Make
//
//  Created by Richmond Starbuck on 4/11/17.
//
//

import UIKit


protocol ColorSelectorDelegate {
    
    
    
}


class ColorSelectorController: ColorSelectorDelegate {
    
    var view: ColorSelectorView
    
    
    init(view: ColorSelectorView) {
        self.view = view
        self.view.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onViewTap(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    
    @objc
    func onViewTap(_ sender: UITapGestureRecognizer) {
        
    }
    
}
