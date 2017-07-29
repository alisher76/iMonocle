//
//  HomeViewController.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/13/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import SpriteKit

class HomeViewController: UIViewController {
    
    let menuImagesNames = ["MFilled", "Twitter", "InstagramLogo", "MoreFilled"]
    
    fileprivate let transition = PopAnimator()
    var index: IndexPath?
    
    @IBOutlet weak var segmentedControllerCollectionView: UICollectionView!
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    @IBOutlet weak var feedsCollectionView: UICollectionView!
    
    var selectedFriend: MonocleUser!
    
    var monocleFriends = [MonocleUser]() {
        didSet {
            FirebaseService.selectedUser = monocleFriends.first
            friendsCollectionView.reloadData()
        }
    }
    var monoclePosts = [MonoclePost]() {
        didSet {
            feedsCollectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegateForCollectionView()
      //  setupMenuBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monocleFriends.removeAll()
        getCurrentListOfFriends()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupMenuBar()  {
        let menuImage = UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal)
        let menuBarButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(handleMenu))
        navigationItem.leftBarButtonItem = menuBarButton
    }
    
    
    //: MARK -  DidSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
            
        case friendsCollectionView:
            if indexPath.row == 0 {
                showFriendsSelectionVC()
            } else {
                selectedFriend = monocleFriends[indexPath.row - 1]
            }
        case segmentedControllerCollectionView:
             updateSegmentMenu(index: indexPath.row)
            
        case feedsCollectionView:
            print("FeedsCell tapped at \(indexPath.row)")
        default:
            break
        }
    }
    
    // Mark: TO:DO
    
    func updateSegmentMenu(index: Int) {
        switch index {
        case 0:
            print("MonocleTapped")
        case 1:
            print("TwitterTapped")
            getTweet(userID: "")
        case 2:
            print("InstagramTapped")
            //checkAccountType(monocleUser: monocleFriends[index])
        case 3:
            print("MoreTapped")
        default:
            break
        }
    }
    
    @objc func handleMenu() {
        print("HandleMenu")
    }
    
    //: MARK Get current list of friends from firebase
    func getCurrentListOfFriends() {
        FirebaseService.currentListOfFriends { (users) in
            for (_,value) in users {
                self.monocleFriends.append(value)
            }
            self.friendsCollectionView.reloadData()
        }
    }
    
    func getTweet(userID: String) {
        TwitterClient.sharedInstance?.getUserTimelineTweet(userID: userID, success: { (tweets) in
            var monoclePosts = [MonoclePost]()
            for tweet in tweets {
                let monoclePost = MonoclePost.tweet(tweet)
                monoclePosts.append(monoclePost)
            }
            self.monoclePosts = monoclePosts
        }, failure: { (error) in
            print("WhatsGoindOn")
        })
        feedsCollectionView.reloadData()
    }
    
    func getUserTimeline(userID: String) {
        
        TwitterClient.sharedInstance?.getUserTimeline(userID: userID, success: { (tweets) in
            self.monoclePosts = tweets
        }, failure: { (error) in
            print("error")
        })
    }
    
    func showFriendsSelectionVC() {
        let storyboard = UIStoryboard(name: "Starter", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FriendsSelectionVC") as! FriendsSelectionViewController
        self.show(vc, sender: self)
    }
    
    func authInstagramVC() {
        let storyboard = UIStoryboard(name: "Starter", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AuthInstagramViewController") as! AuthInstagramViewController
        self.show(vc, sender: self)
    }
    
    func setupDelegateForCollectionView() {
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        
        segmentedControllerCollectionView.delegate = self
        segmentedControllerCollectionView.dataSource = self
        
        feedsCollectionView.delegate = self
        feedsCollectionView.dataSource = self
    }
    
    func instagramSignIn() {
        let userDefault = UserDefaults.standard
        let accessToken = userDefault.object(forKey: "instagramAccessToken") as? String
        if accessToken != nil {
            // get friends list
            let hasInstagramAccountConnected = FirebaseService.checkExistingFriendAccounts(monocleUser: FirebaseService.selectedUser!)
            if hasInstagramAccountConnected {
                
            } else {
                //                delegate?.monoclePosts.removeAll()
                self.feedsCollectionView?.reloadData()
            }
        } else {
            // show do you want to sign in?
            // delegate?.monoclePosts.removeAll()
        }
    }
    
    func checkAccountType(monocleUser: MonocleUser) {
        
        switch monocleUser {
        case .instagramUser(let value):
            monoclePosts.removeAll()
            print(value)
           // getUserTimeline(userID: value.uid)
        case .twitterUser(let value):
            getTweet(userID: value.uid)
            FirebaseService.selectedUser = monocleUser
            if FirebaseService.checkExistingFriendAccounts(monocleUser: monocleUser) == true {
                print("Has InstagramAccount")
                monoclePosts.removeAll()
                // GetInstaFeed
            } else {
                print("no instagram account")
                monoclePosts.removeAll()
            }
        }
    }
    
    // if no do you want to connect?
    func addInstagramFriend() {
        
    }
    
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        
        let selectedCell = feedsCollectionView?.cellForItem(at: index!) as! FeedsCell
        transition.originFrame = selectedCell.postImageView!.superview!.convert(selectedCell.postImageView!.frame, to: nil)
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let selectedCell = feedsCollectionView?.cellForItem(at: index!) as! FeedsCell
        transition.presenting = false
        selectedCell.postImageView!.isHidden = false
        return transition
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let cell = feedsCollectionView?.cellForItem(at: index!) as! FeedsCell
        coordinator.animate(
            alongsideTransition: { context in
                cell.postImageView.alpha = (size.width>size.height) ? 0.25 : 0.55
                self.feedsCollectionView?.reloadData()
        },
            completion: nil
        )
        
    }
    
}


