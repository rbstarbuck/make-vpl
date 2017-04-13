//
//  ColorSelectorView.swift
//  Make
//
//  Created by Richmond Starbuck on 4/11/17.
//
//

import UIKit
import ChromaColorPicker


private let popoverIdentifier = "ColorSelectorPopover"

private let unselectedArrowTintColor = UIColor.gray
private let selectedArrowTintColor = UIColor(hex: 0x3366ff)


class ColorSelectorView: UIViewFromNib {

    @IBOutlet weak var colorIndicatorImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionArrowImage: UIImageView!
    
    
    override func awakeFromNib() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    
    
    func onTap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popover = storyboard.instantiateViewController(withIdentifier: popoverIdentifier) as! ColorSelectorPopoverViewController
        popover.modalPresentationStyle = .popover
        
        if let popoverController = popover.popoverPresentationController {
            popoverController.permittedArrowDirections = .left
            popoverController.delegate = self
            popoverController.sourceView = self
            popoverController.sourceRect = self.bounds
        }
        
        self.selectionArrowImage.tintColor = selectedArrowTintColor
        self.parentViewController?.present(popover, animated: true) {
            self.selectionArrowImage.tintColor = unselectedArrowTintColor
        }
    }
    
    func colorPickerValueChanged(_ sender: ChromaColorPicker) {
        self.setColor(sender.currentColor)
    }
    
    func setColor(_ color: UIColor) {
        self.colorIndicatorImage.tintColor = color
    }
    
}


extension ColorSelectorView: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
}
