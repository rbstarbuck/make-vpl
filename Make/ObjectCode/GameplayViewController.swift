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
        scWorld.gravityMagnitude = 0.05
        scWorld.gravityDirection = .up
        
        let sprite = scWorld.sprites.first!
        sprite.physicsBody.isDynamic = true
        sprite.physicsBody.isAffectedByGravity = true
        
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
