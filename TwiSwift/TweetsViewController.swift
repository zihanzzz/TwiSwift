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
        
        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 100
        
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
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        if let tweet = tweets?[indexPath.row] {
            cell.tweet = tweet
        }
        
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
