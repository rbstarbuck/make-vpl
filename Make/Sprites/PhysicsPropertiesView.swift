//
//  PhysicsPropertiesView.swift
//  Make
//
//  Created by Richmond Starbuck on 1/18/17.
//
//

import UIKit


class PhysicsPropertiesView: UIViewFromNib {
    
    @IBOutlet weak var isDynamicSwitch: UISwitch!
    @IBOutlet weak var isAffectedByGravitySwitch: UISwitch!
    @IBOutlet weak var canRotateSwitch: UISwitch!
    @IBOutlet weak var densitySlider: UISlider!
    @IBOutlet weak var frictionSlider: UISlider!
    @IBOutlet weak var restitutionSlider: UISlider!
    @IBOutlet weak var linearDampingSlider: UISlider!
    @IBOutlet weak var angularDampingSlider: UISlider!
    
    @IBOutlet var dynamicLabels: [UILabel]!
    @IBOutlet var rotationLabels: [UILabel]!
    
    var delegate: PhysicsPropertiesDelegate? {
        didSet {
            if let delegate = self.delegate {
                self.dynamicPropertiesEnabled = delegate.isDynamic
                self.rotationEnabled = delegate.canRotate
                
                self.isDynamicSwitch.isOn = delegate.isDynamic
                self.isAffectedByGravitySwitch.isOn = delegate.isAffectedByGravity
                self.canRotateSwitch.isOn = delegate.canRotate
                self.densitySlider.value = Float(delegate.density)
                self.frictionSlider.value = Float(delegate.friction)
                self.restitutionSlider.value = Float(delegate.restitution)
                self.linearDampingSlider.value = Float(delegate.linearDamping)
                self.angularDampingSlider.value = Float(delegate.angularDamping)
            }
        }
    }
    
    var dynamicPropertiesEnabled: Bool? {
        didSet {
            if let dynamicPropertiesEnabled = self.dynamicPropertiesEnabled {
                for label in self.dynamicLabels {
                    label.isEnabled = dynamicPropertiesEnabled
                }
                self.isAffectedByGravitySwitch.isEnabled = dynamicPropertiesEnabled
                self.canRotateSwitch.isEnabled = dynamicPropertiesEnabled
                self.densitySlider.isEnabled = dynamicPropertiesEnabled
                self.frictionSlider.isEnabled = dynamicPropertiesEnabled
                self.restitutionSlider.isEnabled = dynamicPropertiesEnabled
                self.linearDampingSlider.isEnabled = dynamicPropertiesEnabled
                self.angularDampingSlider.isEnabled = dynamicPropertiesEnabled
                
                if self.rotationEnabled != nil && !self.rotationEnabled! {
                    self.rotationEnabled = false
                }
            }
        }
    }
    
    var rotationEnabled: Bool? {
        didSet {
            if var rotationEnabled = self.rotationEnabled {
                if let dynamic = self.dynamicPropertiesEnabled {
                    rotationEnabled = rotationEnabled && dynamic
                }
                
                for label in self.rotationLabels {
                    label.isEnabled = rotationEnabled
                }
                self.angularDampingSlider.isEnabled = rotationEnabled
            }
        }
    }
    
    
    @IBAction func isDynamicSwitched(_ sender: UISwitch) {
        self.delegate?.isDynamic = sender.isOn
        self.dynamicPropertiesEnabled = sender.isOn
    }
    
    @IBAction func isAffectedByGravitySwitched(_ sender: UISwitch) {
        self.delegate?.isAffectedByGravity = sender.isOn
    }
    
    @IBAction func canRotateSwitched(_ sender: UISwitch) {
        self.delegate?.canRotate = sender.isOn
        self.rotationEnabled = sender.isOn
    }
    
    @IBAction func densityChanged(_ sender: UISlider) {
        self.delegate?.density = Double(sender.value)
    }
    
    @IBAction func frictionChanged(_ sender: UISlider) {
        self.delegate?.friction = Double(sender.value)
    }
    
    @IBAction func restitutionChanged(_ sender: UISlider) {
        self.delegate?.restitution = Double(sender.value)
    }
    
    @IBAction func linearDampingChanged(_ sender: UISlider) {
        self.delegate?.linearDamping = Double(sender.value)
    }
    
    @IBAction func angularDampingChanged(_ sender: UISlider) {
        self.delegate?.angularDamping = Double(sender.value)
    }
    
}
