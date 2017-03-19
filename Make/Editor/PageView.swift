//
//  PageView.swift
//  Make
//
//  Created by Richmond Starbuck on 3/17/17.
//
//

import UIKit


enum PageSwoopDirection {
    case left, down, right, up
}


class PageView: UIView {
    
    var direction = PageSwoopDirection.left
    var duration = TimeInterval(0.75)

    private var swoopConstraints = Dictionary<String, [NSLayoutConstraint]>()
    private var pages = Dictionary<String, UIView>()
    private var currentPage: UIView?
    
    
    func addPage(_ page: UIView, key: String) {
        page.translatesAutoresizingMaskIntoConstraints = false
        page.zPosition = 0
        self.currentPage?.zPosition = -1
        self.currentPage?.isHidden = true
        
        if self.layer.cornerRadius > 0 {
            page.layer.cornerRadius = self.layer.cornerRadius
            page.layer.masksToBounds = true
        }
        
        self.addSubview(page)
        self.pages[key] = page
        
        let lConstraint = NSLayoutConstraint(item: page, attribute: .left, relatedBy: .equal,
                                             toItem: self, attribute: .left, multiplier: 1, constant: 0)
        
        let bConstraint = NSLayoutConstraint(item: page, attribute: .bottom, relatedBy: .equal,
                                             toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        let rConstraint = NSLayoutConstraint(item: page, attribute: .right, relatedBy: .equal,
                                             toItem: self, attribute: .right, multiplier: 1, constant: 0)
        
        let tConstraint = NSLayoutConstraint(item: page, attribute: .top, relatedBy: .equal,
                                             toItem: self, attribute: .top, multiplier: 1, constant: 0)
        
        let constraints = [lConstraint, bConstraint, rConstraint, tConstraint]
        
        self.addConstraints(constraints)
        self.swoopConstraints[key] = constraints
        self.currentPage = page
    }
    
    func showPage(_ key: String, animated: Bool = true) {
        guard let page = self.pages[key] else {
            return
        }
        
        if page == self.currentPage {
            return
        }
        
        self.currentPage?.zPosition = -1
        
        if !animated {
            page.zPosition = 0
            page.isHidden = false
            self.currentPage?.isHidden = true
            self.currentPage = page
        }
        else {
            var constraint: NSLayoutConstraint!
            
            switch self.direction {
            case .left:
                constraint = self.swoopConstraints[key]![0]
                constraint.constant = self.bounds.width
                break
                
            case .down:
                constraint = self.swoopConstraints[key]![1]
                constraint.constant = -self.bounds.height
                break
                
            case .right:
                constraint = self.swoopConstraints[key]![2]
                constraint.constant = -self.bounds.width
                break
                
            case .up:
                constraint = self.swoopConstraints[key]![3]
                constraint.constant = self.bounds.height
                break
            }
            
            page.zPosition = 0
            page.isHidden = false
            self.layoutSubviews()
            
            let previousPage = self.currentPage
            self.currentPage = page
            
            constraint.constant = 0
            UIView.animate(withDuration: self.duration, animations: {
                self.layoutIfNeeded()
            }, completion: {_ in
                previousPage?.isHidden = true
            })
        }
    }
    
}
