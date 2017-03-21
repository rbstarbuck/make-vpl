//
//  PhysicsShapeView.swift
//  Make
//
//  Created by Richmond Starbuck on 3/19/17.
//
//

import UIKit


private var imageViewBorderWidth = CGFloat(1.5)
private var imageViewBorderColor = UIColor.lightGray


class PhysicsShapeView: UIViewFromNib {
    
    @IBOutlet weak var graphicImageView: UIImageView!
    @IBOutlet weak var outlineView: PhysicsShapeOutlineView!
    
    
    var delegate: PhysicsShapeDelegate? {
        didSet {
            if let previousDelegate = oldValue {
                previousDelegate.saveShape()
            }
            self.outlineView.delegate = delegate
            self.configure()
            self.delegate?.setOutlineView()
        }
    }
    
    
    override func awakeFromNib() {
        self.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.onPan(_:)))
        self.outlineView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.onPinch(_:)))
        self.addGestureRecognizer(pinchGesture)
        
        self.outlineView.backgroundColor = UIColor.clear
        self.configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.delegate?.setOutlineView()
    }
    
    
    func configure() {
        if let delegate = self.delegate {
            if let graphic = delegate.sprite.graphic {
                self.graphicImageView.image = graphic.firstFrame.makeImageFromLayers()
                self.graphicImageView.borderColor = imageViewBorderColor
                self.graphicImageView.borderWidth = imageViewBorderWidth
            }
            else {
                self.graphicImageView.image = UIImage(named: "Placeholder image")
                self.graphicImageView.borderWidth = 0
            }
        }
    }
    
    
    func onPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            self.delegate?.panBegan(sender)
            break
            
        case .changed:
            self.delegate?.panChanged(sender)
            break
            
        case .possible: break
            
        default:
            self.delegate?.panEnded(sender)
            break
        }
    }
    
    func onPinch(_ sender: UIPinchGestureRecognizer) {
        if sender.numberOfTouches > 1 {
            switch sender.state {
            case .began:
                self.delegate?.pinchBegan(sender)
                break
                
            case .changed:
                self.delegate?.pinchChanged(sender)
                break
                
            case .possible: break
                
            default:
                self.delegate?.pinchEnded(sender)
                break
            }
        }
    }
    
}
