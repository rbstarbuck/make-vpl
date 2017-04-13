//
//  OCScene.swift
//  Make
//
//  Created by Richmond Starbuck on 1/29/17.
//
//

import SpriteKit


class OCSceneController: NSObject {
    
    var scene: OCScene
    
    var sceneView: OCSceneView
    
    
    init(view: OCSceneView, scene: OCScene) {
        self.sceneView = view
        self.scene = scene
        
        super.init()
        // TODO: delete
        //self.sceneView.showsFPS = true
        //self.sceneView.showsNodeCount = true
        //self.sceneView.showsPhysics = true
        // end delete
        
        self.scene.delegate = self
        self.scene.scaleMode = .fill
        self.sceneView.presentScene(self.scene)
    }
    
}


// These are listed in the order in which they are called within a single tick of a game loop
extension OCSceneController: SKSceneDelegate {

    func update(_ currentTime: TimeInterval, for: SKScene) {
        // The scene’s update(_:) method is called with the time elapsed so far in the simulation. This is the primary place to implement your own in-game simulation, including input handling, artificial intelligence, game scripting, and other similar game logic. Often, you use this method to make changes to nodes or to run actions on nodes.
    }
    
    func didEvaluateActions(for: SKScene) {
        // The scene processes actions on all the nodes in the tree. It finds any running actions and applies those changes to the tree. In practice, because of custom actions, you can also hook into the action mechanism to call your own code. You cannot directly control the order in which actions are processed or cause the scene to skip actions on certain nodes, except by removing the actions from those nodes or removing the nodes from the tree.
        
        // The scene’s didEvaluateActions() method is called after all actions for the frame have been processed.
    }
    
    func didSimulatePhysics(for: SKScene) {
        // The scene simulates physics on nodes in the tree that have physics bodies. Adding physics to nodes in a scene is described in SKPhysicsBody, but the end result of simulating physics is that the position and rotation of nodes in the tree may be adjusted by the physics simulation. Your game can also receive callbacks when physics bodies come into contact with each other, see SKPhysicsContactDelegate.
        
        // The scene’s didSimulatePhysics() method is called after all physics for the frame has been simulated.
    }
    
    func didApplyConstraints(for: SKScene) {
        // The scene applies any constraints associated with nodes in the scene. Constraints are used to establish relationships in the scene. For example, you can apply a constraint that makes sure a node is always pointed at another node, regardless of how it is moved. By using constraints, you avoid needing to write a lot of custom code in your scene handling.
        
        // The scene calls its didApplyConstraints() method.
    }
    
    func didFinishUpdate(for: SKScene) {
        // The scene calls its didFinishUpdate() method. This is your last chance to make changes to the scene.
    }
    
}
