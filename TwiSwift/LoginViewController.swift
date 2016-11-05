//
//  ViewController.swift
//  TwiSwift
//
//  Created by James Zhou on 10/26/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    let magicNumber: CGFloat = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.signUpButton.backgroundColor = UIConstants.twitterPrimaryBlue
        self.signUpButton.setTitleColor(UIColor.white, for: .normal)
        self.signUpButton.titleLabel?.font = UIFont(name: UIConstants.getTextFontNameLight(), size: 18)
        self.signUpButton.layer.cornerRadius = 4
        self.signUpButton.layer.masksToBounds = true
        
        self.loginButton.backgroundColor = UIColor.white
        self.loginButton.setTitleColor(UIConstants.twitterPrimaryBlue, for: .normal)
        self.loginButton.titleLabel?.font = UIFont(name: UIConstants.getTextFontNameLight(), size: 18)

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - magicNumber)
        
        self.view.addSubview(scrollView)
        
        scrollView.delegate = self
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = UIConstants.twitterLightGray
        pageControl.currentPageIndicatorTintColor = UIConstants.twitterDarkGray
        pageControl.addTarget(self, action: #selector(changePage), for: .valueChanged)
        
        let pageWidth = scrollView.bounds.width
        let pageHeight = scrollView.bounds.height
        
        scrollView.contentSize = CGSize(width: 3 * pageWidth, height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
        let view2 = UIView(frame: CGRect(x: pageWidth, y: 0, width: pageWidth, height: pageHeight))
        let view3 = UIView(frame: CGRect(x: 2 * pageWidth, y: 0, width: pageWidth, height: pageHeight))

        configureTitleAndImage(forView: view1, title: "OAuth 1.0a", imageName: "oauth", color: UIColor.black)
        configureTitleAndImage(forView: view2, title: "Swift 3", imageName: "swift", color: UIConstants.swiftColor)
        configureTitleAndImage(forView: view3, title: "Twitter REST API", imageName: "twitter_logo", color: UIConstants.twitterPrimaryBlue)
        
        scrollView.addSubview(view1)
        scrollView.addSubview(view2)
        scrollView.addSubview(view3)
    }
    
    func configureTitleAndImage(forView: UIView, title: String, imageName: String, color: UIColor ) {
        
        let instructionY = forView.bounds.height / 6
        
        let instructionLabel = UILabel()
        instructionLabel.frame = CGRect(x: 0, y: instructionY, width: UIScreen.main.bounds.width, height: 40)
        instructionLabel.text = title
        instructionLabel.textAlignment = .center
        instructionLabel.font = UIFont(name: UIConstants.getTextFontNameBold(), size: 30)
        instructionLabel.textColor = color
        
        forView.addSubview(instructionLabel)
        
        let imageY = instructionY + 40 + 80
        let imageX = (UIScreen.main.bounds.width - 230) / 2
        let instructionImageView = UIImageView()
        instructionImageView.frame = CGRect(x: imageX, y: imageY, width: 230, height: 230)
        instructionImageView.image = UIImage(named: imageName)
        
        forView.addSubview(instructionImageView)
    }
    
    func changePage() {
        let xOffset = scrollView.bounds.width * CGFloat(pageControl.currentPage)
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(self.scrollView.contentOffset.x / self.scrollView.bounds.width)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let twitterSignUpURL = URL(string: "https://twitter.com/signup?lang=en")!
        UIApplication.shared.open(twitterSignUpURL, options: [:], completionHandler: nil)
    }

    
    // TODO: Change to Hamburger VC
    @IBAction func onLogin(_ sender: Any) {
        TwiSwiftClient.sharedInstance?.loginWithCompletion(completionHandler: { (user: User?, error: Error?) in
            if user != nil {

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let hamburgerViewController = storyboard.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
                let leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                hamburgerViewController.leftMenuViewController = leftMenuViewController
                leftMenuViewController.hamburgerViewController = hamburgerViewController
                self.present(hamburgerViewController, animated: true, completion: nil)
                
            } else {
                print("Login failure with error: \(error)")
            }
        })
    }
}

