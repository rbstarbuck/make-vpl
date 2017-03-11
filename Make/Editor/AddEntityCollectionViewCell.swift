//
//  AddEntityCollectionViewCell.swift
//  Make
//
//  Created by Richmond Starbuck on 3/10/17.
//
//

import UIKit

class AddEntityCollectionViewCell: UICollectionViewCell {
    
    var delegate: SelectionDelegate?
    
    
    @IBAction func addButtonTouch(_ sender: Any) {
        self.delegate?.createEntity()
    }
    
}
