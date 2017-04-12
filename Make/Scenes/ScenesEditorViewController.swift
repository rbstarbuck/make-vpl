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

private let referenceParametersViewTrailingDistance = CGFloat(-216)
private let referenceParametersViewHideAnimationDuration = 0.25


class ScenesEditorViewController: UIViewController {

    @IBOutlet weak var nameTextField: NameTextField!
    @IBOutlet weak var gravityView: GravityView!
    
    @IBOutlet weak var contentPageView: PageView!
    @IBOutlet weak var spriteSelectionView: SelectionView!
    
    @IBOutlet weak var bottomView: UIView!
        @IBOutlet weak var referenceParametersView: ScenesReferenceParametersView!
    @IBOutlet weak var referenceParametersViewTrailingConstraint: NSLayoutConstraint!
    
    var connector: SCConnector!
    var scene: SCScene!
    
    var spriteSelectionController: SelectionController!
    var placementController: ScenesPlacementDelegate!
    
    var selectedEntity: NSManagedObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.setName(self.scene.name)
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.layoutSubviews()
        
        self.nameTextField.listeners.insert(self)
        self.nameTextField.entity = self.scene
        
        self.gravityView.entity = self.scene
        
        self.spriteSelectionController = SelectionController(dataSource: self,
                                                             view: self.spriteSelectionView,
                                                             name: SCConstants.SPRITE_DISPLAY_TITLE,
                                                             observer: self.scene.world.spriteObserver)
        self.spriteSelectionController.scrollDirection = .horizontal
        self.spriteSelectionController.cellLength = 1
        
        let placementView = ScenesPlacementView()
        self.placementController = ScenesPlacementController(placementView: placementView,
                                                             parametersView: self.referenceParametersView,
                                                             scene: self.scene)
        self.contentPageView.addPage(placementView, key: placementViewPageKey)
        
        let referencePanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.onReferencePan(_:)))
        placementView.addGestureRecognizer(referencePanGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onPlacementViewTap(_:)))
        placementView.addGestureRecognizer(tapGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.onPlacementViewPinch(_:)))
        placementView.addGestureRecognizer(pinchGesture)
        
        self.setReferenceParametersViewIsHidden(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.spriteSelectionView.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let thumbnail = self.placementController.makeThumbnailFromView() {
            self.scene.thumbnail = thumbnail
        }
        self.scene.world.connector.saveContext()
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
    
    
    private func setReferenceParametersViewIsHidden(animated: Bool) {
        let constant = (self.placementController.selectedReference == nil ? referenceParametersViewTrailingDistance : CGFloat(0))
        
        if animated {
            UIView.animate(withDuration: referenceParametersViewHideAnimationDuration) {
                self.referenceParametersViewTrailingConstraint.constant = constant
                self.bottomView.layoutIfNeeded()
            }
        }
        else {
            self.referenceParametersViewTrailingConstraint.constant = constant
        }
    }
    
    
    func onPlacementViewTap(_ sender: UITapGestureRecognizer) {
        self.placementController.onTap(sender)
        self.setReferenceParametersViewIsHidden(animated: true)
    }
    
    func onSpriteDoubleTap(_ sender: UITapGestureRecognizer) {
        if let source = sender.view as? CoreDataCollectionViewCell {
            self.selectedEntity = source.entity
            self.performSegue(withIdentifier: spriteEditorSegueIdentifier, sender: self)
        }
    }
    
    func onSpriteDrag(_ sender: UILongPressGestureRecognizer) {
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
            self.setReferenceParametersViewIsHidden(animated: true)
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
    
    func onPlacementViewPinch(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            if sender.numberOfTouches > 1 {
                self.placementController.resizeBegan(sender)
            }
            break
            
        case .changed:
            if sender.numberOfTouches > 1 {
                self.placementController.resizeChanged(sender)
            }
            break
            
        case .possible: break
            
        default:
            self.placementController.resizeEnded(sender)
            break
        }
    }
}


extension ScenesEditorViewController: SelectionDataSource {
    
    func configureSelectionCell(_ cell: CoreDataCollectionViewCell, name: String) {
        if name == SCConstants.SPRITE_DISPLAY_TITLE {
            let selectionCell = cell as! SelectionCollectionViewCell
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.onSpriteDrag(_:)))
            longPressGesture.delegate = self
            longPressGesture.minimumPressDuration = 0.5
            selectionCell.addGestureRecognizer(longPressGesture)
            
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onSpriteDoubleTap(_:)))
            doubleTapGesture.delegate = self
            doubleTapGesture.numberOfTapsRequired = 2
            selectionCell.addGestureRecognizer(doubleTapGesture)
        }
    }
    
    func createEntity(name: String) {
        if name == SCConstants.SPRITE_DISPLAY_TITLE {
            self.selectedEntity = self.scene.world.createSprite()
            self.performSegue(withIdentifier: spriteEditorSegueIdentifier, sender: self)
        }
    }
    
    func getImage(for entity: NSManagedObject, name: String) -> UIImage? {
        if name == SCConstants.SPRITE_DISPLAY_TITLE {
            let sprite = entity as! SCSprite
            return sprite.editorImage
        }
        return nil
    }
    
    func getLabel(for entity: NSManagedObject, name: String) -> String? {
        if name == SCConstants.SPRITE_DISPLAY_TITLE {
            let sprite = entity as! SCSprite
            return sprite.name
        }
        return nil
    }
    
}


extension ScenesEditorViewController: NameTextFieldListener {
    
    func setName(_ name: String) {
        self.title = "\(SCConstants.SCENE_DISPLAY_TITLE): \"\(name)\""
    }
    
}


extension ScenesEditorViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UILongPressGestureRecognizer {
            return otherGestureRecognizer is UITapGestureRecognizer
        }
        else if gestureRecognizer is UITapGestureRecognizer {
            return otherGestureRecognizer is UILongPressGestureRecognizer
        }
        return false
    }
    
}
