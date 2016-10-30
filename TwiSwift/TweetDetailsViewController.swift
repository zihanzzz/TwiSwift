//
//  TweetDetailsViewController.swift
//  TwiSwift
//
//  Created by James Zhou on 10/29/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var detailsTableView: UITableView!
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        UIConstants.configureNavBarStyle(forViewController: self, withTitle: "Tweet")
        
        detailsTableView.dataSource = self
        detailsTableView.delegate = self

        detailsTableView.rowHeight = UITableViewAutomaticDimension
        detailsTableView.estimatedRowHeight = 120
        detailsTableView.showsVerticalScrollIndicator = false
        
        
        // remove empty cells
        detailsTableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "TweetContent", for: indexPath) as! TweetCell
            let cell = cell as! TweetCell
            cell.tweet = self.tweet
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "TweetNumbers", for: indexPath) as! TweetNumbersCell
            let cell = cell as! TweetNumbersCell
            cell.tweet = self.tweet
            break
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "TweetActions", for: indexPath) as! TweetCell
            let cell = cell as! TweetCell
            cell.tweet = self.tweet
            break
        default:
            break
        }
        
        cell.selectionStyle = .none
        return cell
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}