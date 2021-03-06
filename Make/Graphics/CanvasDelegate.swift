//
//  CanvasDelegate.swift
//  Make
//
//  Created by Richmond Starbuck on 12/27/16.
//
//

import UIKit


protocol CanvasDelegate: class {
    
    var canvasView: CanvasView { get set }
    var graphic: SCGraphic { get set }
    
    
    func beginDrawing()
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint)
    func drawPoint(at point: CGPoint)
    func commitDrawing()
    
}
