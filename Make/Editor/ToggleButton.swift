//
//  ToggleButton.swift
//  Make
//
//  Created by Richmond Starbuck on 4/1/17.
//
//

import UIKit


private let enabledBackgroundColor = UIColor(hex: 0x4477ff)
private let enabledTintColor = UIColor.white

private let disabledBackgroundColor = UIColor(hex: 0xdddddd)
private let disabledTintColor = UIColor.black


@IBDesignable class ToggleButton: UIButton {

    @IBInspectable var toggled = false {
        didSet {
            self.configure()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.configure()
    }

    
    private func configure() {
        if self.toggled {
            self.backgroundColor = enabledBackgroundColor
            self.tintColor = enabledTintColor
        }
        else {
            self.backgroundColor = disabledBackgroundColor
            self.tintColor = disabledTintColor
        }
    }
    
}
