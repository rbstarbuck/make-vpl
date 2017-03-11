//
//  GameplayViewController.swift
//  Make
//
//  Created by Richmond Starbuck on 2/25/17.
//
//

import UIKit


class GameplayViewController: UIViewController {
    
    @IBOutlet weak var sceneView: OCSceneView!
    
    var connector: SCConnector!
    
    var world: OCWorld!
    
    var sceneController: OCSceneController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: remove test code
        self.connector = SCConnector(context: SCCoreDataStack())
        var scWorld: SCWorld!
        if let w = self.connector.getWorlds().first {
            scWorld = w
        }
        else {
            scWorld = self.connector.createWorld()
        }
        if scWorld.sprites.count == 0 {
            let graphic = scWorld.graphics.first
            let sprite = scWorld.createSprite()
            if graphic != nil {
                sprite.graphic = graphic!
            }
            let scene = scWorld.scenes.first!
            scene.createReference(to: sprite)
            self.connector.saveContext()
        }
        else if scWorld.sprites.count == 1 {
            let graphic = scWorld.graphics.first
            let sprite = scWorld.createSprite()
            if graphic != nil {
                sprite.graphic = graphic!
            }
            sprite.physicsBody.isDynamic = true
            let scene = scWorld.scenes.first!
            let lowerRef = scene.createReference(to: sprite)
            lowerRef.positionY = 0.75
            self.connector.saveContext()
        }
        scWorld.gravityMagnitude = 0.5
        scWorld.gravityDirection = .down
        
        for sprite in scWorld.sprites {
            sprite.physicsBody.isEnabled = true
            sprite.physicsBody.isDynamic = true
            sprite.physicsBody.restitution = 1.0
            sprite.physicsBody.canRotate = true
            if sprite.references.first!.positionY > 0.6 {
                sprite.references.first!.positionX = 0.65
                sprite.references.first!.positionY = 0.9
                sprite.physicsBody.isAffectedByGravity = true
            }
            else {
                sprite.references.first!.positionY = 0.2
                sprite.physicsBody.density = 3.0
            }
        }
        
        self.world = OCWorld(from: scWorld)
        // end test code
        
        self.sceneController = OCSceneController(view: self.sceneView, scene: self.world.activeScene)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
