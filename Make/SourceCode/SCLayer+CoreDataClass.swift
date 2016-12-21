//
//  SCLayer+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import UIKit
import CoreData


public class SCLayer: NSManagedObject {
    public static var entityName = "Layer"
    
    public var imageView: UIImageView {
        get {
            let imageView = UIImageView(image: self.image)
            if let index = self.frame?.layers?.index(of: self) {
                imageView.layer.zPosition = CGFloat(index)
            }
            return imageView
        }
    }
}
