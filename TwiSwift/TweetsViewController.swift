//
//  TweetsViewController.swift
//  TwiSwift
//
//  Created by James Zhou on 10/27/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]?
    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: .valueChanged)
        tweetsTableView.insertSubview(refreshControl, at: 0)

        UIConstants.configureNavBarStyle(forViewController: self, withTitle: "Home")
        
        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 120
        
        // Do any additional setup after loading the view.
        TwiSwiftClient.sharedInstance?.homeTimelineWithParams(params: nil, completionHandler: { (tweets: [Tweet]?, error: Error?) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        User.currentUser?.logout()
    }

    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.selectionStyle = .none
        cell.clearCellState()
        
        if let tweet = tweets?[indexPath.row] {
            cell.tweet = tweet
        }
        
        return cell
    }
    
    // MARK: - Refresh Control
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwiSwiftClient.sharedInstance?.homeTimelineWithParams(params: nil, completionHandler: { (tweets: [Tweet]?, errlr: Error?) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            refreshControl.endRefreshing()
        })
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let tweetDetailsViewController = segue.destination as? TweetDetailsViewController {
            
            if let tweetCell = sender as? TweetCell {
                
                tweetDetailsViewController.tweet = tweetCell.tweet
                
            }
            
            
        }
        
        
        
        
    }
    

}
