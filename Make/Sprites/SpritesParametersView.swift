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
private let graphicBorderWidth = CGFloat(1)


class SpritesParametersView: UIViewFromNib {

    @IBOutlet weak var nameTextField: NameTextField!
    
    @IBOutlet weak var graphicSelectionView: UIView!
    @IBOutlet weak var graphicImageView: UIImageView!
    @IBOutlet weak var graphicLabel: UILabel!
    @IBOutlet weak var graphicArrowImageView: UIImageView!
    @IBOutlet weak var graphicRemoveButton: UIButton!
    
    @IBOutlet weak var physicsSelectionView: UIView!
    @IBOutlet weak var physicsSwitch: UISwitch!
    @IBOutlet weak var physicsArrowImageView: UIImageView!
    
    
    var delegate: SpritesParametersDelegate! {
        didSet {
            self.configure()
        }
    }
    
    
    override func awakeFromNib() {
        self.graphicImageView.borderColor = graphicBorderColor
        self.graphicImageView.borderWidth = graphicBorderWidth
        self.graphicLabel.text = noGraphicName
        
        let graphicTouch = UITapGestureRecognizer(target: self, action: #selector(self.graphicSelectionViewTouch(_:)))
        self.graphicSelectionView.addGestureRecognizer(graphicTouch)
        
        let physicsTouch = UITapGestureRecognizer(target: self, action: #selector(self.physicsViewTouch(_:)))
        self.physicsSelectionView.addGestureRecognizer(physicsTouch)
    }
    
    
    func configure() {
        if let graphic = self.delegate.spriteGraphic {
            self.graphicImageView.image = graphic.firstFrame.makeImageFromLayers()
            self.graphicLabel.text = graphic.name
            self.graphicImageView.borderWidth = graphicBorderWidth
            self.graphicRemoveButton.isHidden = false
            if let background = UIImage(named: "Checker background small") {
                self.graphicImageView.backgroundColor = UIColor(patternImage: background)
            }
            
        }
        else {
            self.graphicImageView.image = UIImage(named: "Placeholder image")
            self.graphicLabel.text = noGraphicName
            self.graphicImageView.borderWidth = 0
            self.graphicRemoveButton.isHidden = true
            self.graphicImageView.backgroundColor = nil
        }
        
        self.physicsSwitch.isOn = self.delegate.spritePhysics.isEnabled
    }
    
    func graphicSelectionViewTouch(_ sender: UITapGestureRecognizer) {
        self.delegate.navigateToGraphicsPage()
    }
    
    func physicsViewTouch(_ sender: UITapGestureRecognizer) {
        self.delegate.navigateToPhysicsPage()
    }
    
    
    @IBAction func graphicRemoveTouch(_ sender: Any) {
        self.delegate.spriteGraphic = nil
        self.configure()
    }
    
    @IBAction func physicsSwitchValueChanged(_ sender: UISwitch) {
        self.delegate.spritePhysics.isEnabled = sender.isOn
    }
    
}

extension SpritesParametersView: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
