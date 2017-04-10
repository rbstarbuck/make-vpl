//
//  BrushController.swift
//  Make
//
//  Created by Richmond Starbuck on 12/29/16.
//
//

import UIKit
import ChromaColorPicker


class BrushController: BrushDelegate {
    
    var brushView: BrushView {
        didSet {
            if self.brushView !== oldValue {
                self.detach(view: oldValue)
                self.attach(view: self.brushView)
            }
        }
    }
    
    let brush: Brush
    
    
    init(view: BrushView, brush: Brush) {
        self.brushView = view
        self.brush = brush
        
        self.attach(view: self.brushView)
    }
    
    private func attach(view: BrushView) {
        view.delegate = self
        view.colorPicker.delegate = self
        view.colorPicker.addTarget(self, action: #selector(self.colorPickerValueChanged(_:)), for: .valueChanged)
        view.brushThicknessSlider.addTarget(self, action: #selector(self.brushThicknessValueChanged(_:)), for: .valueChanged)
        
        self.colorPickerValueChanged(view.colorPicker)
    }
    
    private func detach(view: BrushView) {
        view.delegate = nil
    }
    
}

extension BrushController: ChromaColorPickerDelegate {
    
    @objc
    func brushThicknessValueChanged(_ sender: UISlider) {
        self.brush.width = CGFloat(sender.value)
    }
    
    @objc
    func colorPickerValueChanged(_ sender: ChromaColorPicker) {
        self.brush.color = sender.currentColor
    }
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        //self.brush.color = color
    }
    
}
