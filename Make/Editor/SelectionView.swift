//
//  SelectionView.swift
//  Make
//
//  Created by Richmond Starbuck on 3/8/17.
//
//

import UIKit


class SelectionView: UIViewFromNib {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: SelectionDelegate?
    
    var cellsAreSelected = false {
        didSet {
            let _ = 0
        }
    }
    

}
