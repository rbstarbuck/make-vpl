//
//  AddEntityCollectionViewCell.swift
//  Make
//
//  Created by Richmond Starbuck on 3/10/17.
//
//

import UIKit

class AddEntityCollectionViewCell: UICollectionViewCell {
    
    var delegate: SelectionDelegate? {
        didSet {
            if let delegate = self.delegate {
                label.text = "Add \(delegate.name)"
            }
        }
    }
    
    @IBOutlet weak var label: UILabel!
    
    
    @IBAction func addButtonTouch(_ sender: Any) {
        self.delegate?.createEntity()
    }
    
}
