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
        case accounts = 0, about, deleteAll
    }
    
    var sections = ["Linked Accounts", "About TwitterLite v\(UIConstants.getAppVersion()) (\(UIConstants.getAppBundle()))", "Delete Accounts"]
    
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
        if indexPath.section == SettingsSection.accounts.rawValue {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == SettingsSection.accounts.rawValue {
            if indexPath.row == 0 {
                return 100
            } else if indexPath.row == 1 {
                return 50
            }
        } else if indexPath.section == SettingsSection.about.rawValue {
            return 50
        } else if indexPath.section == SettingsSection.deleteAll.rawValue {
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SettingsSection.accounts.rawValue:
            return 2
        case SettingsSection.about.rawValue:
            return 2
        case SettingsSection.deleteAll.rawValue:
            return 1
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == SettingsSection.accounts.rawValue {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
                cell.selectionStyle = .none
                cell.user = User.currentUser
                return cell
            } else if indexPath.row == 1 {
                let cell = UITableViewCell()
                cell.selectionStyle = .none
                cell.textLabel?.text = "Add another account"
                cell.textLabel?.textColor = UIConstants.twitterPrimaryBlue
                cell.textLabel?.font = UIFont(name: UIConstants.getTextFontNameBold(), size: 16)
                return cell
            }
            
        } else if indexPath.section == SettingsSection.about.rawValue {
            let cell = UITableViewCell()
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "See developer's website"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "See source code on Github"
            }
            
            cell.textLabel?.font = UIFont(name: UIConstants.getTextFontNameLight(), size: 16)
            
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == SettingsSection.deleteAll.rawValue {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Sign Out of All Authorized Accounts"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont(name: UIConstants.getTextFontNameLight(), size: 16)
            cell.textLabel?.textColor = UIColor.red
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case SettingsSection.accounts.rawValue:
            if indexPath.row == 1 {
                let notSupportedAlert = UIAlertController(title: "Not Supported", message: "This feature is not yet supported in this version. Please stay tuned.", preferredStyle: .alert)
                notSupportedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    print("OK")
                }))
                present(notSupportedAlert, animated: true, completion: nil)
            }
            break
        case SettingsSection.about.rawValue:
            if indexPath.row == 0 {
                if let url = URL(string: "http://www.jameszzhou.com/") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else if indexPath.row == 1 {
                if let url = URL(string: "https://github.com/zihanzzz/TwitterLite") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            break
        case SettingsSection.deleteAll.rawValue:
            
            let logoutAlert = UIAlertController(title: "Delete Accounts", message: "Are you sure to remove all authorized accounts?", preferredStyle: .alert)
            logoutAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
                logoutAlert.dismiss(animated: true, completion: nil)
            }))
            logoutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                User.currentUser?.logout()
            }))
            present(logoutAlert, animated: true, completion: nil)
            break
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
