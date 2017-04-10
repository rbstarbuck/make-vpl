//
//  FrameController.swift
//  Make
//
//  Created by Richmond Starbuck on 12/31/16.
//
//

import UIKit
import CoreData


private let cellInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: -7)
private let sectionInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
private let cellAspectRatio = CGFloat(1)


class FrameController: CoreDataCollectionViewController {
    static let frameCellIdentifier = "FrameCollectionViewCell"
    static let addFrameCellIdentifier = "AddFrameCollectionViewCell"
    
    var graphic: SCGraphic {
        didSet {
            if self.graphic !== oldValue {
                self.detach(graphic: oldValue)
                self.attach(graphic: self.graphic)
            }
        }
    }
    
    
    // MARK: - Initialization
    
    init(view: UICollectionView, graphic: SCGraphic) {
        self.graphic = graphic
        
        let frameNib = UINib(nibName: FrameController.frameCellIdentifier, bundle: nil)
        let addFrameNib = UINib(nibName: FrameController.addFrameCellIdentifier, bundle: nil)
        
        view.register(frameNib, forCellWithReuseIdentifier: FrameController.frameCellIdentifier)
        view.register(addFrameNib, forCellWithReuseIdentifier: FrameController.addFrameCellIdentifier)
        
        super.init(view: view, cellIdentifier: FrameController.frameCellIdentifier,
                   observer: self.graphic.frameObserver, populate: false)
        
        self.attach(graphic: self.graphic, populate: false)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(_:)))
        self.collectionView.addGestureRecognizer(longPress)
        
        let initialItemIndexPath = IndexPath(row: 0, section: 0)
        self.collectionView.selectItem(at: initialItemIndexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    private func attach(graphic: SCGraphic, populate: Bool = true) {
        self.observer = graphic.frameObserver
        graphic.frameObserver.addListener(self, populate: populate)
        graphic.selectedFrame.addListener(self, populate: populate)
    }
    
    private func detach(graphic: SCGraphic) {
        graphic.frameObserver.removeListener(self, depopulate: true)
        graphic.selectedFrame.removeListener(self)
    }
    
    
    override func configureCollectionViewController() {
        if let image = UIImage(named: "Film background") {
            self.collectionView.backgroundColor = UIColor(patternImage: image)
        }
        else {
            self.collectionView.backgroundColor = UIColor.black
        }
    }
    
    override func configureCollectionViewLayout() {
        if let layout = self.layout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            
            let cellHeight = self.collectionView.frame.size.height - cellInsets.top - cellInsets.bottom
            let cellWidth = cellHeight * cellAspectRatio
            layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
            
            layout.sectionInset = sectionInsets
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cell = self.collectionView(self.collectionView, cellForItemAt: indexPath)
            if let coreDataCell = cell as? CoreDataCollectionViewCell,
                let frame = coreDataCell.entity as? SCFrame {
                
                self.graphic.selectedFrame.value = frame
            }
        }
    }
    
    func longPressHandler(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self.collectionView)
        
        switch sender.state {
        case .began:
            if let indexPath = self.collectionView.indexPathForItem(at: location),
                let cell = self.collectionView.cellForItem(at: indexPath) as? FrameCollectionViewCell,
                let frame = cell.entity as? SCFrame {
                
                frame.select()
            }
            self.beginDraggingCell(at: location)
            break
            
        case .changed:
            self.onCellDrag(to: location)
            break
            
        default:
            self.endDraggingCell(at: location)
            break
        }
    }
    
    override func moveEntity(_ entity: NSManagedObject, from fromIndex: IndexPath, to toIndex: IndexPath) {
        if let frame = entity as? SCFrame {
            frame.move(to: toIndex.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath,
                        toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if proposedIndexPath.section == 0 {
            return proposedIndexPath
        }
        return originalIndexPath
    }
    
}


// UICollectionViewDelegate overrides to account for "add item" cell
extension FrameController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: FrameController.addFrameCellIdentifier, for: indexPath)
        
        if let coreDataCell = cell as? CoreDataCollectionViewCell {
            coreDataCell.configure(delegate: self, entity: self.graphic)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return super.collectionView(collectionView, numberOfItemsInSection: section)
        }
        
        return 1
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
}


extension FrameController: PropertyListener {
    
    func onPropertyChange(key: String, newValue: Any?, oldValue: Any?) {
        if key == SCGraphic.selectedFrameObserverKey {
            if let selectedFrame = newValue as? SCFrame {
                let selectedIndexPath = IndexPath(row: selectedFrame.index, section: 0)
                self.collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
        }
    }
    
}

