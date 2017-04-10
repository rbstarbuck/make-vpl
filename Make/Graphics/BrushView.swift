//
//  BrushView.swift
//  Make
//
//  Created by Richmond Starbuck on 12/29/16.
//
//

import UIKit
import ChromaColorPicker


class BrushView: UIViewFromNib {
    
    @IBOutlet weak var brushToggle: ToggleButton!
    @IBOutlet weak var eraserToggle: ToggleButton!
    @IBOutlet weak var paintCanToggle: ToggleButton!
    
    @IBOutlet weak var colorPicker: ChromaColorPicker!
    @IBOutlet weak var brushThicknessIcon: UIImageView!
    @IBOutlet weak var brushThicknessSlider: UISlider!

    
    var delegate: BrushDelegate? {
        didSet {
            if let brush = self.delegate?.brush {
                self.colorPicker.adjustToColor(brush.color)
                self.colorPickerValueChanged(self.colorPicker)
                
                self.brushThicknessSlider.setValue(Float(brush.width), animated: true)
                
                switch brush.type {
                case .brush:
                    self.brushToggle.toggled = true
                    break
                case .eraser:
                    self.eraserToggle.toggled = true
                    break
                case .paint:
                    self.paintCanToggle.toggled = true
                    break
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        self.colorPickerValueChanged(self.colorPicker)
        
        /*
        var trackImage = UIImage(named: "Width track")
        trackImage = trackImage?.resizableImage(withCapInsets: .zero, resizingMode: .tile)
        self.brushThicknessSlider.setMinimumTrackImage(trackImage, for: .normal)
        self.brushThicknessSlider.setMaximumTrackImage(trackImage, for: .normal)
        */
        
        self.brushThicknessSlider.minimumValue = Float(Brush.minimumWidth)
        self.brushThicknessSlider.maximumValue = Float(Brush.maximumWidth)
        
        self.colorPicker.hexLabel.isHidden = true
        self.colorPicker.padding = 0
        self.colorPicker.stroke = 2.5
        self.colorPicker.layout()
        
        self.colorPicker.addTarget(self, action: #selector(self.colorPickerValueChanged(_:)), for: .valueChanged)
    }
    
    func colorPickerValueChanged(_ sender: ChromaColorPicker) {
        self.brushThicknessSlider.minimumTrackTintColor = sender.currentColor
    }
    
    @IBAction func brushToggleTouch(_ sender: Any) {
        self.delegate?.brush.type = .brush
        self.colorPicker.isEnabled = true
        self.colorPicker.alpha = 1.0
        self.brushThicknessSlider.isEnabled = true
        self.brushThicknessIcon.alpha = 1.0
        
        self.brushToggle.toggled = true
        self.eraserToggle.toggled = false
        self.paintCanToggle.toggled = false
    }
    
    @IBAction func eraserToggleTouch(_ sender: Any) {
        self.delegate?.brush.type = .eraser
        self.colorPicker.isEnabled = false
        self.colorPicker.alpha = 0.5
        self.brushThicknessSlider.isEnabled = true
        self.brushThicknessIcon.alpha = 1.0
        
        self.brushToggle.toggled = false
        self.eraserToggle.toggled = true
        self.paintCanToggle.toggled = false
    }
    
    @IBAction func paintCanToggleTouch(_ sender: Any) {
        self.delegate?.brush.type = .paint
        self.colorPicker.isEnabled = true
        self.colorPicker.alpha = 1.0
        self.brushThicknessSlider.isEnabled = false
        self.brushThicknessIcon.alpha = 0.5
        
        self.brushToggle.toggled = false
        self.eraserToggle.toggled = false
        self.paintCanToggle.toggled = true
    }
    
}
