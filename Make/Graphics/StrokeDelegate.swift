//
//  StrokeDelegate.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import UIKit


protocol StrokeDelegate {
    var color: UIColor { get set }
    var brushWidth: CGFloat { get set }
    var opacity: CGFloat { get set }
    
    
    func drawToCanvas(_ image: UIImage)
}
