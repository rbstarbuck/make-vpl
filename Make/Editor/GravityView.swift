//
//  GravityView.swift
//  Make
//
//  Created by Richmond Starbuck on 4/10/17.
//
//

import UIKit


private let enabledTintColor = UIColor(hex: 0x3366ff)
private let disabledTintColor = UIColor.lightGray
private let enabledImage = UIImage(named: "Arrow filled")
private let disabledImage = UIImage(named: "Arrow outline")


class GravityView: UIViewFromNib {

    @IBOutlet weak var directionUpButton: UIButton!
    @IBOutlet weak var directionRightButton: UIButton!
    @IBOutlet weak var directionDownButton: UIButton!
    @IBOutlet weak var directionLeftButton: UIButton!
    @IBOutlet weak var magnitudeSlider: UISlider!
    
    
    var entity: SCGravityEntity? {
        didSet {
            self.configure()
        }
    }
    
    
    override func awakeFromNib() {
        self.directionDownButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        self.directionLeftButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.directionUpButton.imageView!.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        self.configure()
    }
    
    
    func configure() {
        self.directionUpButton.tintColor = disabledTintColor
        self.directionRightButton.tintColor = disabledTintColor
        self.directionDownButton.tintColor = disabledTintColor
        self.directionLeftButton.tintColor = disabledTintColor
        
        self.directionUpButton.setImage(disabledImage, for: .normal)
        self.directionRightButton.setImage(disabledImage, for: .normal)
        self.directionDownButton.setImage(disabledImage, for: .normal)
        self.directionLeftButton.setImage(disabledImage, for: .normal)
        
        if let entity = self.entity {
            self.magnitudeSlider.value = Float(entity.gravityMagnitude)
            
            switch entity.gravityDirection {
            case.up:
                self.directionUpButton.tintColor = enabledTintColor
                self.directionUpButton.setImage(enabledImage, for: .normal)
                break
                
            case .right:
                self.directionRightButton.tintColor = enabledTintColor
                self.directionRightButton.setImage(enabledImage, for: .normal)
                break
                
            case .down:
                self.directionDownButton.tintColor = enabledTintColor
                self.directionDownButton.setImage(enabledImage, for: .normal)
                break
                
            case .left:
                self.directionLeftButton.tintColor = enabledTintColor
                self.directionLeftButton.setImage(enabledImage, for: .normal)
                break
            }
        }
    }
    
    
    @IBAction func directionUpButtonTouch(_ sender: Any) {
        self.entity?.gravityDirection = .up
        self.configure()
    }
    
    @IBAction func directionRightButtonTouch(_ sender: Any) {
        self.entity?.gravityDirection = .right
        self.configure()
    }
    
    @IBAction func directionDownButtonTouch(_ sender: Any) {
        self.entity?.gravityDirection = .down
        self.configure()
    }
    
    @IBAction func directionLeftButtonTouch(_ sender: Any) {
        self.entity?.gravityDirection = .left
        self.configure()
    }
    
    @IBAction func magnitudeSliderValueChanged(_ sender: Any) {
        self.entity?.gravityMagnitude = Double(self.magnitudeSlider.value)
    }
    
}
