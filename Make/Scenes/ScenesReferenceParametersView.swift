//
//  ScenesReferenceParametersView.swift
//  Make
//
//  Created by Richmond Starbuck on 3/31/17.
//
//

import UIKit





class ScenesReferenceParametersView: UIViewFromNib {
    
    @IBOutlet weak var scaleSlider: UISlider!
    @IBOutlet weak var rotationSlider: UISlider!
    
    @IBOutlet weak var isAnimatedButton: ToggleButton!
    @IBOutlet weak var flipHorizontalButton: ToggleButton!
    @IBOutlet weak var flipVerticalButton: ToggleButton!
    
    var delegate: ScenesPlacementDelegate! {
        didSet {
            self.configure()
        }
    }
    
    
    override func awakeFromNib() {
        self.scaleSlider.minimumValue = Float(SCReference.minimumRelativeWidth)
        self.scaleSlider.maximumValue = Float(SCReference.maximumRelativeWidth)
        self.rotationSlider.minimumValue = 0.0
        self.rotationSlider.maximumValue = Float.pi
    }
    
    func configure() {
        if let reference = self.delegate?.selectedReference {
            self.scaleSlider.value = Float(reference.relativeWidth)
            self.rotationSlider.value = Float(reference.rotation)
            self.isAnimatedButton.toggled = reference.animated
            self.flipHorizontalButton.toggled = reference.flipX
            self.flipVerticalButton.toggled = reference.flipY
        }
    }

    
    @IBAction func scaleValueChanged(_ sender: Any) {
        if let reference = self.delegate?.selectedReference {
            reference.relativeWidth = Double(self.scaleSlider.value)
            self.delegate!.reloadSelectedReference()
        }
    }
    
    @IBAction func rotationValueChanged(_ sender: Any) {
        if let reference = self.delegate?.selectedReference {
            reference.rotation = Double(self.rotationSlider.value)
            self.delegate!.reloadSelectedReference()
        }
    }
    
    @IBAction func isAnimatedTouch(_ sender: ToggleButton) {
        if let reference = self.delegate?.selectedReference {
            reference.animated = !reference.animated
            sender.toggled = reference.animated
            self.delegate!.reloadSelectedReference()
        }
    }
    
    @IBAction func flipHorizontalTouch(_ sender: ToggleButton) {
        if let reference = self.delegate?.selectedReference {
            reference.flipX = !reference.flipX
            sender.toggled = reference.flipX
            self.delegate!.reloadSelectedReference()
        }
    }
    
    @IBAction func flipVerticalTouch(_ sender: ToggleButton) {
        if let reference = self.delegate?.selectedReference {
            reference.flipY = !reference.flipY
            sender.toggled = reference.flipY
            self.delegate!.reloadSelectedReference()
        }
    }
    
}
