//
//  ScenesReferenceController.swift
//  Make
//
//  Created by Richmond Starbuck on 3/21/17.
//
//

import UIKit


private let draggingViewReturnDuration = 0.5
private let draggingViewAddDuration = 0.5


protocol ScenesPlacementDelegate {
    
    var scene: SCScene { get }
    
    var gameplayViewFrame: CGRect { get }
    
    func reloadData()
    
    func onTap(_ sender: UITapGestureRecognizer)
    
    func dragBegan(_ sender: UIPanGestureRecognizer, in view: UIView)
    func dragChanged(_ sender: UIPanGestureRecognizer, in view: UIView)
    func dragEnded(_ sender: UIPanGestureRecognizer, in view: UIView)
    
    func moveBegan(_ sender: UIPanGestureRecognizer)
    func moveChanged(_ sender: UIPanGestureRecognizer)
    func moveEnded(_ sender: UIPanGestureRecognizer)
    
    func resizeBegan(_ sender: UIPinchGestureRecognizer)
    func resizeChanged(_ sender: UIPinchGestureRecognizer)
    func resizeEnded(_ sender: UIPinchGestureRecognizer)
    
}


class ScenesPlacementController: ScenesPlacementDelegate {
    
    weak var view: ScenesPlacementView?
    var scene: SCScene
    
    var draggingView: UIImageView?
    var draggingSprite: SCSprite?
    var draggingViewReturnRect: CGRect?
    
    var isMoving = false
    
    var gameplayViewFrame: CGRect {
        get {
            if let gameplayView = self.view?.gameplayView {
                return gameplayView.frame
            }
            else {
                return CGRect()
            }
        }
    }
    
    var selectedReference: ScenesReferenceView? {
        didSet {
            oldValue?.isSelected = false
            self.selectedReference?.isSelected = true
        }
    }
    
    var referenceViews = WeakArray<ScenesReferenceView>()
    
    
    init(view: ScenesPlacementView, scene: SCScene) {
        self.view = view
        self.scene = scene
        
        for reference in self.scene.references {
            self.instantiate(reference)
        }
    }
    
    
    @discardableResult
    func instantiate(_ reference: SCReference) -> ScenesReferenceView? {
        if let view = self.view {
            let referenceFrame = reference.frame(in: view.gameplayView.frame)
            let referenceView = ScenesReferenceView(frame: referenceFrame)
            
            referenceView.delegate = self
            referenceView.reference = reference
            view.addSubview(referenceView)
            self.referenceViews.append(referenceView)
            
            return referenceView
        }
        
        return nil
    }
    
    func reloadData() {
        for view in self.referenceViews {
            view.update()
        }
    }
        
}

extension ScenesPlacementController {
    
    func onTap(_ sender: UITapGestureRecognizer) {
        self.selectedReference = self.referenceViewAt(gesture: sender)
    }
    
    func referenceViewAt(gesture: UIGestureRecognizer) -> ScenesReferenceView? {
        var hasSeenSelectedReferenceView = false
        var nextReferenceView: ScenesReferenceView?
        
        for referenceView in self.referenceViews {
            if hasSeenSelectedReferenceView {
                if referenceView.contains(gesture: gesture){
                    nextReferenceView = referenceView
                    break
                }
            }
            else if nextReferenceView == nil && referenceView.contains(gesture: gesture) {
                nextReferenceView = referenceView
            }
            
            if referenceView == self.selectedReference {
                hasSeenSelectedReferenceView = true
            }
        }
        
        return nextReferenceView
    }
    
}

extension ScenesPlacementController {
    
    func moveBegan(_ sender: UIPanGestureRecognizer) {
        if self.selectedReference != nil && self.selectedReference!.contains(gesture: sender) {
            self.isMoving = true
        }
        else if let nextReference = self.referenceViewAt(gesture: sender) {
            self.selectedReference = nextReference
            self.isMoving = true
        }
    }
    
    func moveChanged(_ sender: UIPanGestureRecognizer) {
        if self.isMoving {
            let frame = self.view!.convert(self.selectedReference!.frame, to: self.view!)
            var translation = sender.translation(in: self.view)
            let posX = frame.origin.x + translation.x
            let posY = frame.origin.y + translation.y
            
            if posX >= 0 && posX + self.selectedReference!.bounds.width <= self.view!.bounds.width {
                self.selectedReference!.center.x += translation.x
                self.selectedReference!.reference.centerX += Double(translation.x) / Double(self.gameplayViewFrame.width)
                translation.x = 0
            }
            
            if posY >= 0 && posY + self.selectedReference!.bounds.height <= self.view!.bounds.height {
                self.selectedReference!.center.y += translation.y
                self.selectedReference!.reference.centerY += Double(translation.y) / Double(self.gameplayViewFrame.height)
                translation.y = 0
            }
            
            sender.setTranslation(translation, in: self.view!)
        }
    }
    
    func moveEnded(_ sender: UIPanGestureRecognizer) {
        self.isMoving = false
        self.scene.world.connector.saveContext()
    }
    
}

extension ScenesPlacementController {
    
    func dragBegan(_ sender: UIPanGestureRecognizer, in view: UIView) {
        if self.draggingView == nil {
            if let source = sender.view as? SelectionCollectionViewCell {
                let returnRect = source.imageView.convert(source.imageView.bounds, to: view)
                let sprite = source.entity as! SCSprite
                let dragView =  UIImageView(frame: returnRect)
                dragView.image = sprite.editorImage
                
                let size = self.gameplayViewFrame.width * CGFloat(SCReference.defaultRelativeWidth)
                let scale = size / returnRect.width
                let translation = (returnRect.width - size) / 2.0
                let center = CGPoint(x: dragView.center.x + translation, y: dragView.center.y + translation)
                UIView.animate(withDuration: draggingViewAddDuration) {
                    dragView.transform = CGAffineTransform(scaleX: scale, y: scale)
                    dragView.center = center
                }
                
                view.addSubview(dragView)
                
                self.draggingView = dragView
                self.draggingViewReturnRect = returnRect
                self.draggingSprite = sprite
            }
        }
    }
    
    func dragChanged(_ sender: UIPanGestureRecognizer, in view: UIView) {
        let translation = sender.translation(in: view)
        self.draggingView!.center.x += translation.x
        self.draggingView!.center.y += translation.y
        sender.setTranslation(CGPoint(), in: view)
    }
    
    func dragEnded(_ sender: UIPanGestureRecognizer, in view: UIView) {
        if self.drop(dragView: self.draggingView!) {
            self.draggingView!.removeFromSuperview()
        }
        else {
            let view = self.draggingView!
            let returnRect = self.draggingViewReturnRect!
            UIView.animate(withDuration: draggingViewReturnDuration, animations: {
                view.frame = returnRect
            }, completion: { _ in
                view.removeFromSuperview()
            })
        }
        
        self.draggingView = nil
        self.draggingViewReturnRect = nil
    }
    
    func drop(dragView: UIImageView) -> Bool {
        if let view = self.view {
            if view.contains(view: dragView) {
                let reference = self.draggingSprite!.createReference(in: self.scene)
                let dragCenter = view.parentViewController!.view.convert(dragView.center, to: view.gameplayView)
                reference.centerX = Double(dragCenter.x / view.gameplayView.bounds.width)
                reference.centerY = Double(dragCenter.y / view.gameplayView.bounds.height)
                
                self.scene.world.connector.saveContext()
                self.selectedReference = self.instantiate(reference)
                
                return true
            }
        }
        
        return false
    }
    
}

extension ScenesPlacementController {
    
    func resizeBegan(_ sender: UIPinchGestureRecognizer) {
        
    }
    
    func resizeChanged(_ sender: UIPinchGestureRecognizer) {
        
    }
    
    func resizeEnded(_ sender: UIPinchGestureRecognizer) {
        
    }
    
}
