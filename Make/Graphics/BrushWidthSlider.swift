//
//  BrushWidthSlider.swift
//  Make
//
//  Created by Richmond Starbuck on 4/5/17.
//
//

import UIKit


class BrushWidthSlider: UISlider {
    
    override func awakeFromNib() {
        var trackImage = UIImage(named: "Width track")
        trackImage = trackImage?.resizableImage(withCapInsets: .zero, resizingMode: .tile)
        self.setMinimumTrackImage(trackImage, for: .normal)
        self.setMaximumTrackImage(trackImage, for: .normal)
        //self.maximumTrackTintColor = UIColor.gray
    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return self.bounds
    }
  
}
