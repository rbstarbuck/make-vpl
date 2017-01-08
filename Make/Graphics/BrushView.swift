//
//  BrushView.swift
//  Make
//
//  Created by Richmond Starbuck on 12/29/16.
//
//

import UIKit

class BrushView: UIViewFromNib {

    var delegate: BrushDelegate?
    
    @IBAction func blackTouch(_ sender: Any) {
        self.delegate?.brush.color = UIColor.black
    }
    
    @IBAction func redTouch(_ sender: Any) {
        self.delegate?.brush.color = UIColor.red
    }
    
    @IBAction func greenTouch(_ sender: Any) {
        self.delegate?.brush.color = UIColor.green
    }
    
    @IBAction func blueTouch(_ sender: Any) {
        self.delegate?.brush.color = UIColor.blue
    }
}
