//
//  CanvasController.swift
//  Make
//
//  Created by Richmond Starbuck on 12/21/16.
//
//

import UIKit
import CoreData


class CanvasController: CanvasDelegate {
    
    var canvasView: CanvasView {
        didSet {
            if self.canvasView !== oldValue {
                self.detach(view: oldValue)
                self.attach(view: self.canvasView)
            }
        }
    }
    
    var graphic: SCGraphic {
        didSet {
            if self.graphic !== oldValue {
                self.detach(graphic: oldValue)
                self.attach(graphic: self.graphic)
            }
        }
    }
    
    var frame: SCFrame {
        didSet {
            if self.frame !== oldValue {
                self.detach(frame: oldValue)
                self.attach(frame: self.frame)
            }
        }
    }
    
    var brush: Brush
    
    let inkingSurface = UIImageView()
    
    
    // MARK: - Initialization
    
    init(view: CanvasView, graphic: SCGraphic, brush: Brush) {
        self.canvasView = view
        self.graphic = graphic
        self.frame = graphic.selectedFrame.value!
        self.brush = brush
        
        self.attach(graphic: self.graphic, populate: false)
        self.attach(view: self.canvasView, populate: false)
        self.attach(frame: self.frame, populate: true)
    }
    
    private func attach(graphic: SCGraphic, populate: Bool = true) {
        graphic.selectedFrame.addListener(self, populate: populate)
    }
    
    private func attach(frame: SCFrame, populate: Bool = true) {
        frame.layerObserver.addListener(self, populate: populate)
        frame.selectedLayer.addListener(self, populate: populate)
    }
    
    private func attach(view: CanvasView, populate: Bool = true) {
        view.delegate = self
        if populate {
            self.frame.layerObserver.populateListener(self)
        }
    }
    
    private func detach(graphic: SCGraphic) {
        graphic.selectedFrame.removeListener(self)
    }
    
    private func detach(frame: SCFrame) {
        self.canvasView.removeAllLayers()
        frame.layerObserver.removeListener(self, depopulate: true)
        frame.selectedLayer.removeListener(self)
    }
    
    private func detach(view: CanvasView) {
        view.removeAllLayers()
        view.delegate = nil
    }
    
    
    // MARK: - CanvasDelegate drawing callbacks
    
    func beginDrawing() {
        // no drawing initialization needed (yet)
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        let surfaceSize = self.inkingSurface.frame.size
        UIGraphicsBeginImageContext(surfaceSize)
        
        if let context = UIGraphicsGetCurrentContext() {
            let frameRect = CGRect(x: 0, y: 0, width: surfaceSize.width, height: surfaceSize.height)
            self.inkingSurface.image?.draw(in: frameRect)
            
            context.move(to: fromPoint)
            context.addLine(to: toPoint)
            
            context.setLineCap(.round)
            context.setLineWidth(self.brush.width)
            context.setStrokeColor(self.brush.color.cgColor)
            context.setBlendMode(.normal)
            
            context.strokePath()
            
            self.inkingSurface.image = UIGraphicsGetImageFromCurrentImageContext()
            self.inkingSurface.alpha = self.brush.opacity
        }
        
        UIGraphicsEndImageContext()
    }
    
    func drawPoint(at point: CGPoint) {
        self.drawLine(from: point, to: point)
    }
    
    func commitDrawing() {
        if let layer = self.frame.selectedLayer.value {
            let surfaceSize = self.inkingSurface.frame.size
            UIGraphicsBeginImageContext(surfaceSize)
            
            let imageRect = CGRect(x: 0, y: 0, width: surfaceSize.width, height: surfaceSize.height)
            layer.image.draw(in: imageRect, blendMode: .normal, alpha: 1.0)
            self.inkingSurface.image?.draw(in: imageRect, blendMode: .normal, alpha: self.brush.opacity)
            
            if let imageContext = UIGraphicsGetImageFromCurrentImageContext() {
                layer.image = imageContext
            }
            
            UIGraphicsEndImageContext()
            
            self.inkingSurface.image = nil
            layer.world.connector.saveContext()
        }
    }
    
}


extension CanvasController: EntityListener {
    
    func willChangeEntity(_ key: String) {
        //if key == self.frame?.layerObserver.key {
            
        //}
    }
    
    func onChangeEntity(_ key: String, entity: NSManagedObject, type: NSFetchedResultsChangeType,
                        oldIndex: IndexPath?, newIndex: IndexPath?) {
        //if key == self.frame?.layerObserver.key {
            if let layer = entity as? SCLayer {
                switch type {
                case .delete:
                    self.canvasView.removeLayer(layer)
                    break
                case .insert:
                    self.canvasView.insertLayer(layer)
                    break
                case .move:
                    self.canvasView.setNeedsLayout()
                    break
                case .update: break
                }
            }
        //}
    }
    
    func didChangeEntity(_ key: String) {
        //if key == self.frame?.layerObserver.key {
            
        //}
    }
}


extension CanvasController: PropertyListener {
    
    func onPropertyChange(key: String, newValue: Any?, oldValue: Any?) {
        switch key {
        case SCGraphic.selectedFrameObserverKey:
            if let frame = newValue as? SCFrame {
                self.frame = frame
            }
            break
            
        case SCFrame.selectedLayerObserverKey:
            if let selectedLayer = newValue as? SCLayer {
                self.canvasView.insertInkingSurface(self.inkingSurface, above: selectedLayer)
            }
            break
            
        default: break
        }
    }
    
}
