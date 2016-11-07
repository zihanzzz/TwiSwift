//
//  SettingsViewController.swift
//  TwiSwift
//
//  Created by James Zhou on 11/6/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum SettingsSection: Int {
        case accounts = 0, about
    }
    
    var sections = ["Linked Accounts", "About TwitterLite"]
    
    @IBOutlet weak var settingsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        
        settingsTableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)
        settingsTableView.isScrollEnabled = false

        // remove empty cells
        settingsTableView.tableFooterView = UIView()
        settingsTableView.backgroundColor = UIColor.groupTableViewBackground
        
        self.navigationItem.title = "Settings"
    }
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let logout = UITableViewRowAction(style: .destructive, title: "Log Out", handler: {(action, indexPath) in
            User.currentUser?.logout()
        })
        return [logout]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else if indexPath.section == 1 {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.contentView.backgroundColor = UIColor.groupTableViewBackground
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: UIConstants.getTextFontNameBold(), size: 18)!
        header.textLabel?.textColor = UIConstants.twitterDarkGray
        header.contentView.backgroundColor = UIColor.groupTableViewBackground
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SettingsSection.accounts.rawValue:
            return 1
        case SettingsSection.about.rawValue:
            return 2
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
            cell.selectionStyle = .none
            cell.user = User.currentUser
            return cell
        } else if indexPath.section == 1 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "About"
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
