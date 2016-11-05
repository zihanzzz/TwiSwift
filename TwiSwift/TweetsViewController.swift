//
//  TweetsViewController.swift
//  TwiSwift
//
//  Created by James Zhou on 10/27/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate, TweetCellDelegate, UIScrollViewDelegate {
    
    var tweets: [Tweet]?
    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    var isMoreDataLoading = false
    
    var loadingMoreView: InfiniteScrollActivityView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Infinite Scroll Loading indicator
        let frame = CGRect(x: 0, y: self.tweetsTableView.contentSize.height, width: self.tweetsTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        self.tweetsTableView.addSubview(loadingMoreView!)
        
        var insets = self.tweetsTableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        self.tweetsTableView.contentInset = insets
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewTweet(_:)), name: UIConstants.UserEventEnum.newTweet.notification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeleteTweet(_:)), name: UIConstants.UserEventEnum.deleteTweet.notification, object: nil)
        
        let composeImageView = UIImageView(image: UIImage(named: "compose"))
        composeImageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let rightBarButton = UIBarButtonItem.init(customView: composeImageView)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let composeTap = UITapGestureRecognizer(target: self, action: #selector(onNewTweet))
        composeTap.numberOfTapsRequired = 1
        composeImageView.addGestureRecognizer(composeTap)
        
        
        // FIXME: change logout to hamburger
        let logoutImageView = UIImageView(image: UIImage(named: "hamburger"))
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
        NotificationCenter.default.post(name: UIConstants.HamburgerEventEnum.didOpen.notification, object: nil, userInfo: nil)
//        let logoutAlert = UIAlertController(title: "Log Out", message: "Are you sure to log out of TwitterLite?", preferredStyle: .alert)
//        logoutAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
//            logoutAlert.dismiss(animated: true, completion: nil)
//        }))
//        logoutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
//            User.currentUser?.logout()
//        }))
//        present(logoutAlert, animated: true, completion: nil)
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
        
        let newestId = self.tweets?.first?.remoteId as Any
        let params = ["since_id": newestId]
        
        TwiSwiftClient.sharedInstance?.homeTimelineWithParams(params: params, completionHandler: { (tweets: [Tweet]?, errlr: Error?) in
            if let newTweets = tweets {
                if newTweets.count > 0 {
                    self.tweets = tweets
                    self.tweetsTableView.reloadData()
                }
            }
            refreshControl.endRefreshing()
        })
    }
    
    // MARK: - Scroll View Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (!isMoreDataLoading) {
            
            let scrollViewContentHeight = self.tweetsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - self.tweetsTableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tweetsTableView.isDragging) {
                
                isMoreDataLoading = true
    
                let frame = CGRect(x: 0, y: self.tweetsTableView.contentSize.height, width: self.tweetsTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                self.loadingMoreView?.frame = frame
                self.loadingMoreView?.startAnimating()

                let oldestId = self.tweets?.last?.remoteIdStr as Any
                let params = ["max_id": oldestId]
                TwiSwiftClient.sharedInstance?.homeTimelineWithParams(params: params, completionHandler: { (tweets: [Tweet]?, error: Error?) in
                    
                    self.loadingMoreView?.stopAnimating()
                    self.isMoreDataLoading = false
                    
                    if let newTweets = tweets {
                        
                        if newTweets.count > 0 {
                            self.tweets?.removeLast()
                        }
                        
                        for newTweet in newTweets {
                            self.tweets?.append(newTweet)
                            self.tweetsTableView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    // MARK: - Handle Notifications (New Tweet & Delete Tweet)
    func handleNewTweet(_ notification: NSNotification) {
        if let newTweet = notification.userInfo?["tweet"] as? Tweet {
            if (tweets == nil) {
                tweets = [Tweet]()
            }
            tweets?.insert(newTweet, at: 0)
            tweetsTableView.reloadData()
        }
    }
    
    func handleDeleteTweet(_ notification: NSNotification) {
        if let newTweet = notification.userInfo?["tweet"] as? Tweet {
            if (tweets == nil) {
                tweets = [Tweet]()
            }
            
            let deletedTweetIndex = self.tweets?.index(of: newTweet)
            
            self.tweets?.remove(at: deletedTweetIndex!)
            
            tweetsTableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let tweetDetailsViewController = segue.destination as? TweetDetailsViewController {
            if let tweetCell = sender as? TweetCell {
                tweetDetailsViewController.tweet = tweetCell.tweet
            }
        }
    }
    
    // MARK: - Tweet Cell Delegate
    func tweetCell(tweetCell: TweetCell, didTapReply tweet: Tweet) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewTweet") as! UINavigationController
        
        if let newTweetViewController = vc.topViewController as? NewTweetViewController {
            newTweetViewController.replyingTweet = tweet
        }
        
        self.present(vc, animated: true, completion: nil)
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
