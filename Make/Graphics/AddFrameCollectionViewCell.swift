//
//  AddFrameCollectionViewCell.swift
//  Make
//
//  Created by Richmond Starbuck on 1/7/17.
//
//

import UIKit


class AddFrameCollectionViewCell: CoreDataCollectionViewCell {

    @IBAction func addFrameTouch(_ sender: Any) {
        if let viewController = self.parentViewController, let graphic = self.entity as? SCGraphic {
            let selectedFrame = graphic.selectedFrame.value!
            let lastFrame = graphic.lastFrame
            
            let alertController = UIAlertController(title: "Add an animation frame", message: nil, preferredStyle: .actionSheet)
            
            let copyCurrent = UIAlertAction(title: "Copy This Frame", style: .default) { (_ UIAlertAction) -> Void in
                graphic.selectedFrame.value = selectedFrame.copyFrame()
            }
            
            let copyLast = UIAlertAction(title: "Copy the Last Frame", style: .default) { (_ UIAlertAction) -> Void in
                graphic.selectedFrame.value = lastFrame.copyFrame()
            }
            
            let createNew = UIAlertAction(title: "Create a New Frame", style: .default) { (_ UIAlertAction) -> Void in
                graphic.selectedFrame.value = graphic.createFrame()
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(copyCurrent)
            if lastFrame.index != selectedFrame.index {
                alertController.addAction(copyLast)
            }
            alertController.addAction(createNew)
            alertController.addAction(cancel)
            
            alertController.popoverPresentationController?.barButtonItem = UIBarButtonItem(customView: self)
            viewController.present(alertController, animated: true)
        }
    }
    
}
