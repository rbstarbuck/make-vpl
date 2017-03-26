//
//  ScenesEditorViewController.swift
//  Make
//
//  Created by Richmond Starbuck on 3/21/17.
//
//

import UIKit
import CoreData


private let placementViewPageKey = "placement"
private let spriteEditorSegueIdentifier = "SpritesEditorViewControllerSegue"


class ScenesEditorViewController: UIViewController {

    @IBOutlet weak var contentPageView: PageView!
    @IBOutlet weak var spriteSelectionView: SelectionView!
    
    var connector: SCConnector!
    var scene: SCScene!
    
    var spriteSelectionController: SelectionController!
    var placementController: ScenesPlacementDelegate!
    
    var selectedEntity: NSManagedObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: delete
        self.connector = SCConnector(context: SCCoreDataStack())
        if let world = self.connector.getWorlds().first {
            self.scene = world.scenes.first!
        }
        else {
            let world = self.connector.createWorld()
            self.scene = world.scenes.first!
        }
        // end delete        
        self.title = "\(SCConstants.SCENE_DISPLAY_TITLE): \"\(self.scene.name)\""
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.layoutSubviews()
        
        self.spriteSelectionController = SelectionController(dataSource: self,
                                                             view: self.spriteSelectionView,
                                                             name: SCConstants.SPRITE_DISPLAY_TITLE,
                                                             observer: self.scene.world.spriteObserver)
        self.spriteSelectionController.scrollDirection = .horizontal
        self.spriteSelectionController.cellLength = 1
        
        self.spriteSelectionController.getImage = { entity in
            let sprite = entity as! SCSprite
            return sprite.editorImage
        }
        
        self.spriteSelectionController.getLabel = { entity in
            let sprite = entity as! SCSprite
            return sprite.name
        }
        
        let placementView = ScenesPlacementView()
        self.placementController = ScenesPlacementController(view: placementView, scene: self.scene)
        self.contentPageView.addPage(placementView, key: placementViewPageKey)
        
        let referencePanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.onReferencePan(_:)))
        placementView.addGestureRecognizer(referencePanGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onPlacementViewTap(_:)))
        placementView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.spriteSelectionView.collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        self.placementController.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == spriteEditorSegueIdentifier {
            let spritesEditor = segue.destination as! SpritesEditorViewController
            spritesEditor.connector = self.connector
            spritesEditor.sprite = self.selectedEntity as! SCSprite
        }
    }
    
    
    func onPlacementViewTap(_ sender: UITapGestureRecognizer) {
        self.placementController.onTap(sender)
    }
    
    func onSpriteDrag(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            if sender.numberOfTouches > 0 {
                self.placementController.dragBegan(sender, in: self.view)
            }
            break
            
        case .changed:
            if sender.numberOfTouches > 0 {
                self.placementController.dragChanged(sender, in: self.view)
            }
            break
            
        case .possible: break
            
        default:
            self.placementController.dragEnded(sender, in: self.view)
            break
        }
    }
    
    func onReferencePan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            if sender.numberOfTouches > 0 {
                self.placementController.moveBegan(sender)
            }
            break
            
        case .changed:
            if sender.numberOfTouches > 0 {
                self.placementController.moveChanged(sender)
            }
            break
            
        case .possible: break
            
        default:
            self.placementController.moveEnded(sender)
            break
        }
    }
}


extension ScenesEditorViewController: SelectionDataSource {
    
    func configureSelectionCell(_ cell: CoreDataCollectionViewCell, name: String) {
        if name == SCConstants.SPRITE_DISPLAY_TITLE {
            let selectionCell = cell as! SelectionCollectionViewCell
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.onSpriteDrag(_:)))
            selectionCell.addGestureRecognizer(panGesture)
        }
    }
    
    func createEntity(name: String) {
        if name == SCConstants.SPRITE_DISPLAY_TITLE {
            self.selectedEntity = self.scene.world.createSprite()
            self.performSegue(withIdentifier: spriteEditorSegueIdentifier, sender: self)
        }
    }
    
}
