//
//  ScenesReferenceController.swift
//  Make
//
//  Created by Richmond Starbuck on 3/21/17.
//
//

import UIKit


protocol ScenesPlacementDelegate {
    
    var scene: SCScene { get }
    
    var gameplayViewScale: Double { get }
    var gameplayViewSize: CGSize { get }
    var gameplayViewFrame: CGRect { get }
    
    @discardableResult func drop(dragView: ScenesReferenceDragView) -> Bool
    
}


class ScenesPlacementController: ScenesPlacementDelegate {
    
    weak var view: ScenesPlacementView?
    var scene: SCScene
    
    var gameplayViewScale: Double
    
    var gameplayViewSize: CGSize {
        get {
            if let view = self.view {
                return view.gameplayView.bounds.size
            }
            else {
                return CGSize()
            }
        }
    }
    
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
    
    
    init(view: ScenesPlacementView, scene: SCScene) {
        self.view = view
        self.scene = scene
        
        self.gameplayViewScale = Double(view.gameplayView.bounds.width / UIScreen.main.bounds.width)
        
        for reference in self.scene.references {
            self.instantiate(reference)
        }
    }
    
    
    @discardableResult
    func drop(dragView: ScenesReferenceDragView) -> Bool {
        if let view = self.view {
            if view.contains(view: dragView) {
                let reference = dragView.sprite.createReference(in: self.scene)
                let dragCenter = view.parentViewController!.view.convert(dragView.center, to: view.gameplayView)
                reference.centerX = Double(dragCenter.x / view.gameplayView.bounds.width)
                reference.centerY = Double(dragCenter.y / view.gameplayView.bounds.height)
                print("x = \(reference.centerX), y = \(reference.centerY)")
                
                self.scene.world.connector.saveContext()
                self.instantiate(reference)
                
                return true
            }
        }
        
        return false
    }
    
    func instantiate(_ reference: SCReference) {
        if let view = self.view {
            let referenceFrame = reference.frame(in: view.gameplayView.frame)
            let referenceView = ScenesReferenceView(frame: referenceFrame)
            referenceView.delegate = self
            referenceView.reference = reference
            
            view.addSubview(referenceView)
            
            self.selectedReference = referenceView
        }
    }
    
}


