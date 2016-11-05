//
//  HamburgerViewController.swift
//  TwiSwift
//
//  Created by James Zhou on 11/5/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var leftMenuViewController: LeftMenuViewController!
    
    var originalLeftMargin: CGFloat!
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.closeLeftMenu()
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // TODO: DELETE THIS CODE
        if (contentViewController == nil) {
            contentViewController = UIViewController()
            contentViewController.view.backgroundColor = UIColor.green
        }

        // "grab" view of menu view controller
        menuView.addSubview(leftMenuViewController.view)
        
        
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(onPanGesture(_:)))
        self.contentView.addGestureRecognizer(panGestureRecognizer)
    }
    
    func onPanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = panGestureRecognizer.translation(in: self.view)
        let velocity = panGestureRecognizer.translation(in: self.view)
        
        switch panGestureRecognizer.state {
        case .began:
            originalLeftMargin = leftMarginConstraint.constant
            break
        case .changed:
            
            leftMarginConstraint.constant = originalLeftMargin + translation.x
            
            break
            
        case .ended:
            
            
            UIView.animate(withDuration: 0.2, animations: {
                if velocity.x > 0 {
                    self.openLeftMenu()
                } else {
                    self.closeLeftMenu()
                }
                self.view.layoutIfNeeded()
            })

            break
        
        default:
            
            break
        }
    }
    
    func openLeftMenu() {
        self.leftMarginConstraint.constant = self.view.frame.size.width - 100
    }
    
    func closeLeftMenu() {
        self.leftMarginConstraint.constant = 0
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
