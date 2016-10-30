//
//  TweetsViewController.swift
//  TwiSwift
//
//  Created by James Zhou on 10/27/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

@objc protocol TweetsViewControllerDelegate {
    @objc optional func tweetsViewController(tweetsViewController: TweetsViewController, didChooseRetweet tweet: Tweet)
}

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate, TweetCellDelegate {
    
    var tweets: [Tweet]?
    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    weak var delegate: TweetsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: .valueChanged)
        tweetsTableView.insertSubview(refreshControl, at: 0)

        let logoImage = UIImage(named: "twitter_logo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        logoImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logoImageView
        
        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 120
        
        // Do any additional setup after loading the view.
        TwiSwiftClient.sharedInstance?.homeTimelineWithParams(params: nil, completionHandler: { (tweets: [Tweet]?, error: Error?) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
        })
        
        if #available(iOS 9, *) {
            if (traitCollection.forceTouchCapability == UIForceTouchCapability.available) {
                registerForPreviewing(with: self, sourceView: self.tweetsTableView)
                // It's important that the sourceView is set to the tableView instead of self.view
                // Otherwise previewingContext.sourceRect will cause issues! (different coordinate system)
                // but don't self.businessTableView and self.view have the same frame? No they don't (different width and height)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewTweet(_:)), name: UserEventEnum.newTweet.notification, object: nil)
        
        let composeImageView = UIImageView(image: UIImage(named: "compose"))
        composeImageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let rightBarButton = UIBarButtonItem.init(customView: composeImageView)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let composeTap = UITapGestureRecognizer(target: self, action: #selector(onNewTweet))
        composeTap.numberOfTapsRequired = 1
        composeImageView.addGestureRecognizer(composeTap)
        
        let logoutImageView = UIImageView(image: UIImage(named: "logout"))
        logoutImageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let leftBarButton = UIBarButtonItem.init(customView: logoutImageView)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let logoutTap = UITapGestureRecognizer(target: self, action: #selector(onLogOut))
        logoutTap.numberOfTapsRequired = 1
        logoutImageView.addGestureRecognizer(logoutTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onLogOut() {
        let logoutAlert = UIAlertController(title: "Log Out", message: "Are you sure to log out of TwitterLite?", preferredStyle: .alert)
        logoutAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            logoutAlert.dismiss(animated: true, completion: nil)
        }))
        logoutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            User.currentUser?.logout()
        }))
        present(logoutAlert, animated: true, completion: nil)
    }
    
    func onNewTweet() {
        performSegue(withIdentifier: "newTweetSegue", sender: self)
    }
    
    

    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.selectionStyle = .none
        cell.clearCellState()
        
        cell.delegate = self
        cell.tweetsViewController = self
        
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
    
    // MARK: - New Tweet
    func handleNewTweet(_ notification: NSNotification) {
        if let newTweet = notification.userInfo?["tweet"] as? Tweet {
            if (tweets == nil) {
                tweets = [Tweet]()
            }
            tweets?.insert(newTweet, at: 0)
            tweetsTableView.reloadData()
        }
    }
    
    // MARK: - Tweet Cell Delegate for Retweets
    func tweetCell(tweetCell: TweetCell, didTapRetweetButton tweet: Tweet, retweetAvailable: Bool) {
        let retweetAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if (retweetAvailable) {
            retweetAlert.addAction(UIAlertAction(title: "Retweet", style: .default, handler: { (action) in
                self.delegate?.tweetsViewController?(tweetsViewController: self, didChooseRetweet: tweet)
            }))
        } else {
            retweetAlert.addAction(UIAlertAction(title: "Undo Retweet", style: .destructive, handler: { (action) in
                self.delegate?.tweetsViewController?(tweetsViewController: self, didChooseRetweet: tweet)
            }))
            
        }
        retweetAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            // Nothing here
        }))
        present(retweetAlert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let tweetDetailsViewController = segue.destination as? TweetDetailsViewController {
            if let tweetCell = sender as? TweetCell {
                tweetDetailsViewController.tweet = tweetCell.tweet
            }
        }
    }
    
    // MARK: - 3D Touch Preview
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = self.tweetsTableView.indexPathForRow(at: location) else {return nil}
        guard let cell = self.tweetsTableView.cellForRow(at: indexPath) else {return nil}
        
        previewingContext.sourceRect = cell.frame
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TweetDetailsViewController") as! TweetDetailsViewController
        
        vc.tweet = self.tweets?[indexPath.row]

        let preferredWidth = self.view.frame.size.width - 50
        vc.preferredContentSize = CGSize(width: preferredWidth, height: preferredWidth)
        
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }


}
