//
//  ColorSelectorView.swift
//  Make
//
//  Created by Richmond Starbuck on 4/11/17.
//
//

import UIKit

class ColorSelectorView: UIViewFromNib {

    @IBOutlet weak var colorIndicatorImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionArrowImage: UIImageView!
    
    var delegate: ColorSelectorDelegate?
    
    
    override func awakeFromNib() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    
    
    func onTap(_ sender: UITapGestureRecognizer) {
        
    }
    
}
