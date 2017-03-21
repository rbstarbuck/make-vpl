//
//  PhysicsController.swift
//  Make
//
//  Created by Richmond Starbuck on 3/19/17.
//
//

import UIKit


protocol PhysicsDelegate {
    
    var sprite: SCSprite { get }
    
    func configure()
    
    func setShape(_ type: PhysicsShape)
    
}


class PhysicsController: PhysicsDelegate {
    
    weak var view: PhysicsView?
    
    var sprite: SCSprite
    
    var shapeController: PhysicsShapeDelegate
    var propertiesController: PhysicsPropertiesDelegate
    
    
    init(view: PhysicsView, sprite: SCSprite) {
        self.view = view
        self.sprite = sprite
        
        self.propertiesController = PhysicsPropertiesController(view: view.propertiesView, physicsBody: sprite.physicsBody)
        
        switch sprite.physicsBody.shape.type {
        case .rectangle:
            self.shapeController = PhysicsShapeRectangleController(view: view.shapeView, sprite: self.sprite)
            break
            
        case .circle:
            self.shapeController = PhysicsShapeCircleController(view: view.shapeView, sprite: self.sprite)
            break
        }
        
        self.shapeController.delegate = self
    }
    
    
    func configure() {
        self.shapeController.configure()
        self.propertiesController.configure()
    }
    
    func setShape(_ type: PhysicsShape) {
        if let view = self.view {
            var controller: PhysicsShapeController!
            
            switch type {
            case .rectangle:
                controller = PhysicsShapeRectangleController(view: view.shapeView, previous: self.shapeController)
                break
                
            case .circle:
                controller = PhysicsShapeCircleController(view: view.shapeView, previous: self.shapeController)
                break
            }
            
            controller.delegate = self
            self.shapeController = controller
        }
    }
}
