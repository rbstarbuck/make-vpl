//
//  SpritesParametersView.swift
//  Make
//
//  Created by Richmond Starbuck on 3/11/17.
//
//

import UIKit
import Material


private let noGraphicName = "None Selected"

private let graphicBorderColor = UIColor.lightGray
private let graphicBorderWidth = CGFloat(2)


class SpritesParametersView: UIViewFromNib {

    @IBOutlet weak var nameTextField: TextField!
    
    @IBOutlet weak var graphicSelectionView: UIView!
    @IBOutlet weak var graphicImageView: UIImageView!
    @IBOutlet weak var graphicLabel: UILabel!
    @IBOutlet weak var graphicArrowImageView: UIImageView!
    @IBOutlet weak var graphicRemoveButton: UIButton!
    
    @IBOutlet weak var physicsSelectionView: UIView!
    @IBOutlet weak var physicsSwitch: Switch!
    @IBOutlet weak var physicsArrowImageView: UIImageView!
    
    
    var delegate: SpritesParametersDelegate! {
        didSet {
            self.configure()
        }
    }
    
    
    override func awakeFromNib() {
        self.nameTextField.returnKeyType = .done
        self.nameTextField.font = UIFont.systemFont(ofSize: 22.0)
        
        self.graphicImageView.borderColor = graphicBorderColor
        self.graphicImageView.borderWidth = graphicBorderWidth
        self.graphicLabel.text = noGraphicName
        
        let graphicTouch = UITapGestureRecognizer(target: self, action: #selector(self.graphicSelectionViewTouch(_:)))
        self.graphicSelectionView.addGestureRecognizer(graphicTouch)
        
        let physicsTouch = UITapGestureRecognizer(target: self, action: #selector(self.physicsViewTouch(_:)))
        self.physicsSelectionView.addGestureRecognizer(physicsTouch)
    }
    
    
    func configure() {
        self.nameTextField.text = self.delegate.spriteName
        
        if let graphic = self.delegate.spriteGraphic {
            self.graphicImageView.image = graphic.firstFrame.makeImageFromLayers()
            self.graphicLabel.text = graphic.name
            self.graphicImageView.borderWidth = graphicBorderWidth
            self.graphicRemoveButton.isHidden = false
        }
        else {
            self.graphicImageView.image = UIImage(named: "Placeholder image")
            self.graphicLabel.text = noGraphicName
            self.graphicImageView.borderWidth = 0
            self.graphicRemoveButton.isHidden = true
        }
    }
    
    func graphicSelectionViewTouch(_ sender: UITapGestureRecognizer) {
        self.delegate.selectGraphics()
    }
    
    func physicsViewTouch(_ sender: UITapGestureRecognizer) {
        self.delegate.selectPhysics()
    }
    
    
    @IBAction func nameEditingChanged(_ sender: Any) {
        if let name = self.nameTextField.text {
            self.delegate.spriteName = name
        }
        else {
            self.delegate.spriteName = ""
        }
    }
    
    @IBAction func graphicRemoveTouch(_ sender: Any) {
        self.delegate.spriteGraphic = nil
        self.configure()
    }
    
    @IBAction func physicsSwitchValueChanged(_ sender: Any) {
        
    }
    @IBAction func didEndOnExit(_ sender: UIView) {
        sender.resignFirstResponder()
    }
    
    
}

extension SpritesParametersView: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
