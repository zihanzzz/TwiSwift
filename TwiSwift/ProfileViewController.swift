//
//  ProfileViewController.swift
//  TwiSwift
//
//  Created by James Zhou on 11/5/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
