//
//  TweetDetailsViewController.swift
//  TwiSwift
//
//  Created by James Zhou on 10/29/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate {

    @IBOutlet weak var detailsTableView: UITableView!
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTableView.dataSource = self
        detailsTableView.delegate = self

        detailsTableView.rowHeight = UITableViewAutomaticDimension
        detailsTableView.estimatedRowHeight = 120
        detailsTableView.showsVerticalScrollIndicator = false
        
        // remove empty cells
        detailsTableView.tableFooterView = UIView()
        
        //reply button
        let replyImageView = UIImageView(image: UIImage(named: "reply-colored"))
        replyImageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let rightBarButton = UIBarButtonItem.init(customView: replyImageView)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let replyTap = UITapGestureRecognizer(target: self, action: #selector(onReply))
        replyTap.numberOfTapsRequired = 1
        replyImageView.addGestureRecognizer(replyTap)
    }
    
    func onReply() {
        onReplyWithTweet(tweet: self.tweet)
    }
    
    func onReplyWithTweet(tweet: Tweet) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewTweet") as! UINavigationController
        
        if let newTweetViewController = vc.topViewController as? NewTweetViewController {
            newTweetViewController.replyingTweet = tweet
        }
        self.present(vc, animated: true, completion: nil)
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
            cell.delegate = self
            break
        default:
            break
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Tweet Cell Delegate
    func tweetCell(tweetCell: TweetCell, didTapReply tweet: Tweet) {
        onReplyWithTweet(tweet: tweet)
    }
    
    func tweetCell(tweetCell: TweetCell, didFinishRetweet tweet: Tweet) {
        self.tweet = tweet
        self.detailsTableView.reloadData()
    }
    
    func tweetCell(tweetCell: TweetCell, didFinishFavorite tweet: Tweet) {
        self.tweet = tweet
        self.detailsTableView.reloadData()
    }
    
    // MARK: - Preview
    override var previewActionItems: [UIPreviewActionItem] {
        
        var actions = [UIPreviewAction]()

        let screenname = (tweet.originalComposer?.screenname!)!
        let twitterAction = UIPreviewAction(title: "@\(screenname) in Twitter", style: .default) { (previewAction, viewController) in
            if (UIApplication.shared.canOpenURL(URL(string: "twitter://")!)) {
                UIApplication.shared.open(URL(string: "twitter://user?screen_name=\(screenname)")!, options: [:], completionHandler: nil)
            }
        }
        
        let dismissAction = UIPreviewAction(title: "Cancel", style: .default) { (previewAction, viewController) in
            self.dismiss(animated: true, completion: nil)
        }
        
        let deleteAction = UIPreviewAction(title: "Delete Tweet", style: .destructive) { (previewAction, viewController) in
            
            TwiSwiftClient.sharedInstance?.deleteTweet(tweetIdString: "\(self.tweet.remoteId!)", completionHandler: { (tweet: Tweet?, error: Error?) in
                if (tweet != nil) {
                    print("delete succeeded")
                    
                    let userInfo:[String: Tweet] = ["tweet": self.tweet]
                    NotificationCenter.default.post(name: UIConstants.UserEventEnum.deleteTweet.notification, object: nil, userInfo: userInfo)
                    
                } else {
                    print("delete failed")
                }
            })
        }
        
        actions.append(twitterAction)
        actions.append(dismissAction)
        
        if User.isCurrentUser(user: tweet.originalComposer!) {
            actions.insert(deleteAction, at: 0)
        }

        return actions
    }
}
