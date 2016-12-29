//
//  LayerTableViewCell.swift
//  Make
//
//  Created by Richmond Starbuck on 12/29/16.
//
//

import UIKit

class LayerTableViewCell: CoreDataTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
