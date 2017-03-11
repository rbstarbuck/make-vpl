//
//  SpritesParametersView.swift
//  Make
//
//  Created by Richmond Starbuck on 3/11/17.
//
//

import UIKit
import Material


class SpritesParametersView: UIViewFromNib {

    @IBOutlet weak var nameTextField: TextField!
    
    var delegate: SpritesParametersDelegate?
    
    
    @IBAction func nameTextFieldEditingDidEnd(_ sender: Any) {
    }
    
}
