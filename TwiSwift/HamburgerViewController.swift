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
    
    var tapGestureRecognizer: UITapGestureRecognizer?
    
    var isLeftMenuOpen = false

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
            
            self.closeLeftMenu()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observer
        NotificationCenter.default.addObserver(self, selector: #selector(didOpenMenu), name: UIConstants.HamburgerEventEnum.didOpen.notification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didCloseMenu), name: UIConstants.HamburgerEventEnum.didClose.notification, object: nil)
        
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
        
        tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer!.numberOfTapsRequired = 1
        tapGestureRecognizer!.addTarget(self, action: #selector(onTapGesture(_:)))
        
        self.contentView.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    func onTapGesture(_ tapGestureRecognizer: UITapGestureRecognizer) {
        if (isLeftMenuOpen) {
            self.closeLeftMenu()
        }
    }
    
    func onPanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = panGestureRecognizer.translation(in: self.view)
        let velocity = panGestureRecognizer.translation(in: self.view)
        
        switch panGestureRecognizer.state {
        case .began:
            originalLeftMargin = leftMarginConstraint.constant
            break
        case .changed:
            
            let openingConditions = !isLeftMenuOpen && velocity.x > 0
            let closingConditions = isLeftMenuOpen && velocity.x < 0
            
            if (openingConditions || closingConditions) {
                leftMarginConstraint.constant = originalLeftMargin + translation.x
            }
            
            break
        case .ended:
            if velocity.x > 0 {
                self.openLeftMenu()
            } else {
                self.closeLeftMenu()
            }
            break
        default:
            break
        }
    }
    
    func didOpenMenu() {
        self.openLeftMenu()
    }
    
    func didCloseMenu() {
        self.closeLeftMenu()
    }
    
    func openLeftMenu() {
        UIView.animate(withDuration: UIConstants.getLeftMenuAnimationSpeed(), animations: {
            self.leftMarginConstraint.constant = 220
            self.view.layoutIfNeeded() // This has to be insde the animation block in order for animation to work
        })
        self.isLeftMenuOpen = true
        self.contentViewController.view.isUserInteractionEnabled = false
        tapGestureRecognizer?.isEnabled = true
    }
    
    func closeLeftMenu() {
        UIView.animate(withDuration: UIConstants.getLeftMenuAnimationSpeed(), animations: {
            self.leftMarginConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
        self.isLeftMenuOpen = false
        self.contentViewController.view.isUserInteractionEnabled = true
        tapGestureRecognizer?.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
