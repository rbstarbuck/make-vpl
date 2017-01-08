//
//  FrameworkExtensions.swift
//  PlanIt
//
//  Created by Richmond Starbuck on 10/16/16.
//  Copyright © 2016 OneTwo Productions. All rights reserved.
//

import UIKit


extension Collection {
    
    subscript (safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
    
}


extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
}


extension UIView {
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        let nibName = String(describing: type(of: self))
        guard let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0] as? T else {
            // xib not loaded, or it's top view is of the wrong type
            return nil
        }
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.constrainEdgesToParent(self)
        return view
    }
    
    func constrainEdgesToParent(_ parent: UIView, margin: Int = 0) {
        let viewDict = ["view": self]
        let vfl = "|-\(margin)-[view]-\(margin)-|"
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:\(vfl)", options: [], metrics: nil, views: viewDict)
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:\(vfl)", options: [], metrics: nil, views: viewDict)
        parent.addConstraints(vConstraints + hConstraints)
    }
    
    var parentViewController: UIViewController? {
        get {
            if let controller = self.next as? UIViewController {
                return controller
            }
            else if let view = self.next as? UIView {
                return view.parentViewController
            }
            return nil
        }
    }
    
}

class UIViewFromNib: UIView {
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        self.fromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.fromNib()
    }
    
}
