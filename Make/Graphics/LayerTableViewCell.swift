//
//  LayerTableViewCell.swift
//  Make
//
//  Created by Richmond Starbuck on 12/29/16.
//
//

import UIKit
import CoreData


private var imageViewBorderWidth = CGFloat(0.5)
private var imageViewBorderColor = UIColor.gray


class LayerTableViewCell: CoreDataTableViewCell {

    @IBOutlet weak var layerImageView: UIImageView!
    @IBOutlet weak var layerImageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var deleteAction: ((UITableViewCell) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layerImageView.layer.borderWidth = imageViewBorderWidth
        self.layerImageView.layer.borderColor = imageViewBorderColor.cgColor
        
        if let image = UIImage(named: "Checker background extra-small") {
            self.layerImageView.backgroundColor = UIColor(patternImage: image)
        }
    }

    override func configure(delegate: CoreDataTableViewDelegate, entity: NSManagedObject) {
        super.configure(delegate: delegate, entity: entity)
        
        if let layer = entity as? SCLayer {
            self.layerImageView.image = layer.image
            self.nameLabel.text = layer.name
            self.deleteAction = { (cell) in
                layer.delete()
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            self.nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        }
        else {
            self.nameLabel.font = UIFont.systemFont(ofSize: 22)
        }
    }
    
    @IBAction func deleteLayerTouch(_ sender: Any) {
        self.deleteAction?(self)
    }
    
}
