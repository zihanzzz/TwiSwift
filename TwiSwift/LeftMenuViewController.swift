//
//  LeftMenuViewController.swift
//  TwiSwift
//
//  Created by James Zhou on 11/4/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var leftMenuTableView: UITableView!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController!
    
    private var tweetsNavigationViewController: UINavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up VCs
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tweetsNavigationViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationViewController") as! UINavigationController
        
        
        viewControllers.append(tweetsNavigationViewController)
        

        leftMenuTableView.dataSource = self
        leftMenuTableView.delegate = self
        
        leftMenuTableView.backgroundColor = UIConstants.twitterPrimaryBlue
        leftMenuTableView.separatorColor = UIColor.white
        
        // remove empty cells
        leftMenuTableView.tableFooterView = UIView()
        
        // set up initial VC
        hamburgerViewController.contentViewController = tweetsNavigationViewController
    }
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIConstants.twitterPrimaryBlue
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell", for: indexPath) as! LeftMenuCell
        
        cell.backgroundColor = UIConstants.twitterPrimaryBlue
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.setUpMenu(menuText: "Timeline", menuImageName: "home")
            break
        case 1:
            cell.setUpMenu(menuText: "Profile", menuImageName: "profile")
            break
        case 2:
            cell.setUpMenu(menuText: "Mentions", menuImageName: "mention")
            break
        case 3:
            cell.setUpMenu(menuText: "Logout", menuImageName: "logout-white")
        default:
            break
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
