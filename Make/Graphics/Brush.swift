//
//  Brush.swift
//  Make
//
//  Created by Richmond Starbuck on 12/29/16.
//
//

import UIKit


enum BrushType {
    case brush, eraser, paint
}


class Brush {
    
    static let minimumWidth = CGFloat(2.5)
    static let maximumWidth = CGFloat(40)
    
    
    var type = BrushType.brush
    var color = UIColor.blue
    var width = CGFloat(10)
    var opacity = CGFloat(1.0)
    
}
