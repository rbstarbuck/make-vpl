//
//  ScenesReferenceController.swift
//  Make
//
//  Created by Richmond Starbuck on 3/21/17.
//
//

import UIKit


private let draggingViewReturnDuration = 0.5
private let draggingViewAddDuration = 0.25


protocol ScenesPlacementDelegate {
    
    var scene: SCScene { get }
    var selectedReference: SCReference? { get }
    
    var gameplayViewFrame: CGRect { get }
    
    func reloadData()
    func reloadSelectedReference()
    
    func onTap(_ sender: UITapGestureRecognizer)
    
    func dragBegan(_ sender: UILongPressGestureRecognizer, in view: UIView)
    func dragChanged(_ sender: UILongPressGestureRecognizer, in view: UIView)
    func dragEnded(_ sender: UILongPressGestureRecognizer, in view: UIView)
    
    func moveBegan(_ sender: UIPanGestureRecognizer)
    func moveChanged(_ sender: UIPanGestureRecognizer)
    func moveEnded(_ sender: UIPanGestureRecognizer)
    
    func resizeBegan(_ sender: UIPinchGestureRecognizer)
    func resizeChanged(_ sender: UIPinchGestureRecognizer)
    func resizeEnded(_ sender: UIPinchGestureRecognizer)
    
}


class ScenesPlacementController: ScenesPlacementDelegate {
    
    weak var placementView: ScenesPlacementView?
    weak var parametersView: ScenesReferenceParametersView?
    var scene: SCScene
    
    var draggingView: UIImageView?
    var draggingSprite: SCSprite?
    var draggingViewReturnRect: CGRect?
    
    var isMoving = false
    
    var previousTouch1: CGPoint!
    var previousTouch2: CGPoint!
    
    var referenceViews = WeakArray<ScenesReferenceView>()
    
    var gameplayViewFrame: CGRect {
        get {
            if let gameplayView = self.placementView?.gameplayView {
                return gameplayView.frame
            }
            else {
                return CGRect()
            }
        }
    }
    
    var selectedReferenceView: ScenesReferenceView? {
        didSet {
            oldValue?.isSelected = false
            self.selectedReferenceView?.isSelected = true
            self.parametersView?.configure()
        }
    }
    
    var selectedReference: SCReference? {
        get {
            return self.selectedReferenceView?.reference
        }
    }
    
    
    init(placementView: ScenesPlacementView, parametersView: ScenesReferenceParametersView, scene: SCScene) {
        self.placementView = placementView
        self.parametersView = parametersView
        self.scene = scene
        
        placementView.delegate = self
        parametersView.delegate = self
        
        for reference in self.scene.references {
            self.instantiate(reference)
        }
    }
    
    
    @discardableResult
    func instantiate(_ reference: SCReference) -> ScenesReferenceView? {
        if let view = self.placementView {
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
    
    func reloadSelectedReference() {
        self.selectedReferenceView?.update()
    }
    
}


extension ScenesPlacementController {
    
    func onTap(_ sender: UITapGestureRecognizer) {
        self.selectedReferenceView = self.referenceViewAt(gesture: sender)
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
            
            if referenceView == self.selectedReferenceView {
                hasSeenSelectedReferenceView = true
            }
        }
        
        return nextReferenceView
    }
    
}


extension ScenesPlacementController {
    
    func dragBegan(_ sender: UILongPressGestureRecognizer, in view: UIView) {
        if self.draggingView == nil {
            if let source = sender.view as? SelectionCollectionViewCell {
                self.previousTouch1 = sender.location(in: view)
                
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
    
    func dragChanged(_ sender: UILongPressGestureRecognizer, in view: UIView) {
        if let previousTouch = self.previousTouch1 {
            let currentTouch = sender.location(in: view)
            self.draggingView!.center.x += currentTouch.x - previousTouch.x
            self.draggingView!.center.y += currentTouch.y - previousTouch.y
            self.previousTouch1 = currentTouch
        }
    }
    
    func dragEnded(_ sender: UILongPressGestureRecognizer, in view: UIView) {
        if let draggingView = self.draggingView {
            if self.drop(dragView: draggingView) {
                draggingView.removeFromSuperview()
            }
            else {
                let returnRect = self.draggingViewReturnRect!
                UIView.animate(withDuration: draggingViewReturnDuration, animations: {
                    draggingView.frame = returnRect
                }, completion: { _ in
                    draggingView.removeFromSuperview()
                })
            }
            
            self.draggingView = nil
            self.draggingViewReturnRect = nil
        }
        
    }
    
    func drop(dragView: UIImageView) -> Bool {
        if let view = self.placementView {
            if view.contains(view: dragView) {
                let reference = self.draggingSprite!.createReference(in: self.scene)
                let dragCenter = view.parentViewController!.view.convert(dragView.center, to: view.gameplayView)
                reference.centerX = Double(dragCenter.x / view.gameplayView.bounds.width)
                reference.centerY = Double(dragCenter.y / view.gameplayView.bounds.height)
                
                self.scene.world.connector.saveContext()
                self.selectedReferenceView = self.instantiate(reference)
                
                return true
            }
        }
        
        return false
    }
    
}


extension ScenesPlacementController {
    
    func moveBegan(_ sender: UIPanGestureRecognizer) {
        if self.selectedReferenceView != nil && self.selectedReferenceView!.contains(gesture: sender) {
            self.isMoving = true
        }
        else if let nextReference = self.referenceViewAt(gesture: sender) {
            self.selectedReferenceView = nextReference
            self.isMoving = true
        }
    }
    
    func moveChanged(_ sender: UIPanGestureRecognizer) {
        if self.isMoving {
            let frame = self.placementView!.convert(self.selectedReferenceView!.frame, to: self.placementView!)
            var translation = sender.translation(in: self.placementView)
            var translationReset = CGPoint()
            
            let posX = frame.origin.x + translation.x
            let posY = frame.origin.y + translation.y
            
            if posX < 0 {
                translationReset.x = translation.x + frame.origin.x
                translation.x = -frame.origin.x
            }
            else if posX + frame.width > self.placementView!.bounds.width {
                let diffX = self.placementView!.bounds.width - frame.origin.x - frame.width
                translationReset.x = translation.x - diffX
                translation.x = diffX
            }
            
            if posY < 0 {
                translationReset.y = translation.y + frame.origin.y
                translation.y = -frame.origin.y
            }
            else if posY + frame.height > self.placementView!.bounds.height {
                let diffY = self.placementView!.bounds.height - frame.origin.y - frame.height
                translationReset.y = translation.y - diffY
                translation.y = diffY
            }
            
            self.selectedReference!.centerX += Double(translation.x) / Double(self.gameplayViewFrame.width)
            self.selectedReference!.centerY += Double(translation.y) / Double(self.gameplayViewFrame.height)
            self.selectedReferenceView!.updateTransform()
            
            sender.setTranslation(translationReset, in: self.placementView!)
        }
    }
    
    func moveEnded(_ sender: UIPanGestureRecognizer) {
        self.isMoving = false
        self.scene.world.connector.saveContext()
    }
    
}


extension ScenesPlacementController {
    
    func resizeBegan(_ sender: UIPinchGestureRecognizer) {
        if self.selectedReferenceView != nil {
            self.previousTouch1 = sender.location(ofTouch: 0, in: self.placementView)
            self.previousTouch2 = sender.location(ofTouch: 1, in: self.placementView)
        }
    }
    
    func resizeChanged(_ sender: UIPinchGestureRecognizer) {
        if let selectedReferenceView = self.selectedReferenceView {
            let touch1 = sender.location(ofTouch: 0, in: self.placementView!)
            let touch2 = sender.location(ofTouch: 1, in: self.placementView!)
            let referencePosition = self.placementView!.convert(selectedReferenceView.frame.origin, to: self.placementView!)
            
            let prevDistance = self.previousTouch1.distance(to: self.previousTouch2)
            let currDistance = touch1.distance(to: touch2)
            
            let diff = currDistance - prevDistance
            let size = selectedReferenceView.bounds.width + diff
            let translation = (size - selectedReferenceView.bounds.width) / 2.0
            let posX = referencePosition.x - translation
            let posY = referencePosition.y - translation
            
            let scaleDiff = diff / self.placementView!.gameplayView.bounds.width
            let relativeWidth = selectedReferenceView.reference.relativeWidth + Double(scaleDiff)
            
            if relativeWidth >= SCReference.minimumRelativeWidth
                    && posX >= 0 && posX + size <= self.placementView!.bounds.width
                    && posY >= 0 && posY + size <= self.placementView!.bounds.height {
                selectedReferenceView.reference.relativeWidth = relativeWidth
                selectedReferenceView.updateTransform()
                self.parametersView?.configure()
                self.previousTouch1 = touch1
                self.previousTouch2 = touch2
            }
        }
    }
    
    func resizeEnded(_ sender: UIPinchGestureRecognizer) {
        self.selectedReferenceView?.updateTransform()
    }
    
    func pinchDistance(of gesture: UIPinchGestureRecognizer) -> CGFloat {
        let p1 = gesture.location(ofTouch: 0, in: self.placementView)
        let p2 = gesture.location(ofTouch: 1, in: self.placementView)
        return p1.distance(to: p2)
    }
    
}
