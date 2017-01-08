//
//  BrushController.swift
//  Make
//
//  Created by Richmond Starbuck on 12/29/16.
//
//

import UIKit


class BrushController: BrushDelegate {
    
    var brushView: BrushView {
        didSet {
            if self.brushView !== oldValue {
                self.detach(view: oldValue)
                self.attach(view: self.brushView)
            }
        }
    }
    
    var brush: Brush
    
    
    init(view: BrushView, brush: Brush) {
        self.brushView = view
        self.brush = brush
        
        self.attach(view: self.brushView)
    }
    
    private func attach(view: BrushView) {
        view.delegate = self
    }
    
    private func detach(view: BrushView) {
        view.delegate = nil
    }
    
}
