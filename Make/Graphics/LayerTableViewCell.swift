//
//  LayerTableViewCell.swift
//  Make
//
//  Created by Richmond Starbuck on 12/29/16.
//
//

import UIKit
import CoreData


class LayerTableViewCell: CoreDataTableViewCell {

    @IBOutlet weak var layerImageView: UIImageView!
    @IBOutlet weak var layerImageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func configure(delegate: CoreDataTableViewDelegate, entity: NSManagedObject) {
        super.configure(delegate: delegate, entity: entity)
        
        if let layer = entity as? SCLayer {
            self.layerImageView.image = layer.image
            self.nameLabel.text = layer.name
            
            /*if layer.image.size.height > 0 {
                let imageAspectRatio = layer.image.size.width / layer.image.size.height
                let imageViewWidth = self.layerImageView.frame.height * imageAspectRatio
                self.layerImageViewWidthConstraint.constant = imageViewWidth
            }*/
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            self.nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        }
        else {
            self.nameLabel.font = UIFont.systemFont(ofSize: 22)
        }
    }
    
}
