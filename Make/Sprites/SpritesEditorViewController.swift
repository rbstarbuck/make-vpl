//
//  SpritesEditorViewController.swift
//  Make
//
//  Created by Richmond Starbuck on 1/19/17.
//
//

import UIKit

class SpritesEditorViewController: UIViewController {
    
    @IBOutlet weak var physicsPropertiesView: PhysicsPropertiesView!
    
    var connector = SCConnector(context: SCCoreDataStack())
    
    var world: SCWorld!
    var sprite: SCSprite!
    
    var physicsPropertiesController: PhysicsPropertiesDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        let worlds = self.connector.getWorlds()
        if let world = worlds.first {
            self.world = world
        }
        else {
            self.world = self.connector.createWorld()
        }
        
        if let sprite = self.world.sprites.first {
            self.sprite = sprite
        }
        else {
            self.sprite = self.world.createSprite()
        }
        
        self.physicsPropertiesController = PhysicsPropertiesController(view: self.physicsPropertiesView,
                                                                       physicsBody: self.sprite.physicsBody)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
