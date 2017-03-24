//
//  ScenesEditorViewController.swift
//  Make
//
//  Created by Richmond Starbuck on 3/21/17.
//
//

import UIKit
import CoreData


private let draggingViewReturnDuration = 0.5

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
    
    var draggingView: ScenesReferenceDragView?
    var draggingViewReturnRect: CGRect?
    
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.spriteSelectionView.collectionView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == spriteEditorSegueIdentifier {
            let spritesEditor = segue.destination as! SpritesEditorViewController
            spritesEditor.connector = self.connector
            spritesEditor.sprite = self.selectedEntity as! SCSprite
        }
    }
}


extension ScenesEditorViewController: SelectionDataSource {
    
    func configureSelectionCell(_ cell: CoreDataCollectionViewCell, name: String) {
        if name == SCConstants.SPRITE_DISPLAY_TITLE {
            let selectionCell = cell as! SelectionCollectionViewCell
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.onPan(_:)))
            selectionCell.addGestureRecognizer(panGesture)
        }
    }
    
    func createEntity(name: String) {
        if name == SCConstants.SPRITE_DISPLAY_TITLE {
            self.selectedEntity = self.scene.world.createSprite()
            self.performSegue(withIdentifier: spriteEditorSegueIdentifier, sender: self)
        }
    }
    
    
    func onPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            if sender.numberOfTouches > 0 {
                self.onPanBegan(sender)
            }
            break
            
        case .changed:
            if sender.numberOfTouches > 0 {
                self.onPanChanged(sender)
            }
            break
            
        case .possible: break
            
        default:
            self.onPanEnded(sender)
            break
        }
    }
    
    func onPanBegan(_ sender: UIPanGestureRecognizer) {
        if self.draggingView == nil {
            if let source = sender.view as? SelectionCollectionViewCell {
                self.draggingViewReturnRect = source.imageView.convert(source.imageView.bounds, to: self.view)
                self.draggingView = ScenesReferenceDragView(frame: self.draggingViewReturnRect!)
                self.draggingView!.sprite = source.entity as! SCSprite
                self.view.addSubview(self.draggingView!)
            }
        }
    }
    
    func onPanChanged(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        self.draggingView!.center.x += translation.x
        self.draggingView!.center.y += translation.y
        sender.setTranslation(CGPoint(), in: self.view)
    }
    
    func onPanEnded(_ sender: UIPanGestureRecognizer) {
        if self.placementController.drop(dragView: self.draggingView!) {
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
    
}
