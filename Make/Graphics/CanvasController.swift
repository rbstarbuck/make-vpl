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
    
    var frame: SCFrame? {
        didSet {
            if self.frame !== oldValue {
                oldValue?.layerObserver.removeListener(self)
                if let frame = self.frame {
                    frame.layerObserver.addListener(self)
                    self.fillCanvasViewLayers()
                    self.currentLayer = frame.sortedLayers.last!
                }
            }
        }
    }
    
    var canvasView: CanvasView? {
        didSet {
            if self.canvasView !== oldValue {
                oldValue?.delegate = nil
                self.canvasView?.delegate = self
                self.fillCanvasViewLayers()
            }
        }
    }
    
    var currentLayer: SCLayer? {
        didSet {
            if let currentLayer = self.currentLayer {
                let zIndex = CGFloat(currentLayer.index) + 0.5
                self.inkingSurface.layer.zPosition = zIndex
            }
        }
    }
    
    var inkingSurface = UIImageView()
    
    var brushColor: UIColor = .black
    var brushWidth: CGFloat = 10.0
    var brushOpacity: CGFloat = 1.0
    
    
    private func fillCanvasViewLayers() {
        if let canvasView = self.canvasView {
            canvasView.removeAllLayers()
            canvasView.insertLayer(self.inkingSurface)
            if let frame = self.frame {
                for layer in frame.layers {
                    canvasView.insertLayer(layer.imageView)
                }
            }
        }
    }
    
    // MARK: - CanvasDelegate drawing callbacks
    
    func beginDrawing() {}
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        let surfaceSize = self.inkingSurface.frame.size
        UIGraphicsBeginImageContext(surfaceSize)
        
        if let context = UIGraphicsGetCurrentContext() {
            let frameRect = CGRect(x: 0, y: 0, width: surfaceSize.width, height: surfaceSize.height)
            self.inkingSurface.image?.draw(in: frameRect)
            
            context.move(to: fromPoint)
            context.addLine(to: toPoint)
            
            context.setLineCap(.round)
            context.setLineWidth(self.brushWidth)
            context.setStrokeColor(self.brushColor.cgColor)
            context.setBlendMode(.normal)
            
            context.strokePath()
            
            self.inkingSurface.image = UIGraphicsGetImageFromCurrentImageContext()
            self.inkingSurface.alpha = self.brushOpacity
        }
        
        UIGraphicsEndImageContext()
    }
    
    func drawPoint(at point: CGPoint) {
        self.drawLine(from: point, to: point)
    }
    
    func commitDrawing() {
        if let currentImageView = self.currentLayer?.imageView {
            let surfaceSize = self.inkingSurface.frame.size
            UIGraphicsBeginImageContext(currentImageView.frame.size)
            
            let imageRect = CGRect(x: 0, y: 0, width: surfaceSize.width, height: surfaceSize.height)
            currentImageView.image?.draw(in: imageRect, blendMode: .normal, alpha: 1.0)
            self.inkingSurface.image?.draw(in: imageRect, blendMode: .normal, alpha: self.brushOpacity)
            
            if let imageContext = UIGraphicsGetImageFromCurrentImageContext() {
                currentImageView.image = imageContext
            }
            
            self.inkingSurface.image = nil
            UIGraphicsEndImageContext()
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
                    self.canvasView?.removeLayer(layer.imageView)
                    break
                case .insert:
                    self.canvasView?.insertLayer(layer.imageView)
                    break
                case .move: break
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
