//
//  FrameController.swift
//  Make
//
//  Created by Richmond Starbuck on 12/31/16.
//
//

import UIKit
import CoreData

private let reuseIdentifier = "FrameCollectionViewCell"
private let addFrameReuseIdentifier = "AddFrameCollectionViewCell"
private let cellInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
private let sectionInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
private let cellAspectRatio = CGFloat(1)


class FrameController: CoreDataCollectionViewController {
    
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
        
        let frameNib = UINib(nibName: reuseIdentifier, bundle: nil)
        let addFrameNib = UINib(nibName: addFrameReuseIdentifier, bundle: nil)
        
        view.register(frameNib, forCellWithReuseIdentifier: reuseIdentifier)
        view.register(addFrameNib, forCellWithReuseIdentifier: addFrameReuseIdentifier)
        
        super.init(view: view, cellIdentifier: reuseIdentifier, observer: self.graphic.frameObserver, populate: false)
        
        self.attach(graphic: self.graphic, populate: false)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(_:)))
        self.collectionView.addGestureRecognizer(longPress)
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
        self.collectionView.backgroundColor = UIColor.black
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
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: addFrameReuseIdentifier, for: indexPath)
        
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
        /*if key == SCGraphic.selectedFrameObserverKey {
            
        }*/
    }
    
}

