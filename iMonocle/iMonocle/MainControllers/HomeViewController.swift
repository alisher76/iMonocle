//
//  HomeViewController.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/13/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import SpriteKit

private let menuReuseIdentifier = "menuCell"
private let feedReuseIdentifier = "feedCell"
private let tweetReuseIdentifier = "tweetCell"
private let friendsReuseIdentifier = "friendsCell"
private let signInReuseIdentifier = "signInCell"
private let dateReuseIdentifier = "dateCell"

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            if monocleFriends.count > 0 {
            checkAccountType(monocleUser: monocleFriends[0])
            }
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
        setupMenuBar()
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
    
    
    // MARK: UICollectionViewDataSource
    
    func setupMenuBar()  {
        let menuImage = UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal)
        let menuBarButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(handleMenu))
        navigationItem.leftBarButtonItem = menuBarButton
    }
    //: MARK - Number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    //: MARK - NumberOfItems Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == friendsCollectionView {
            return monocleFriends.count + 1
        } else if collectionView == segmentedControllerCollectionView {
            return 4
        } else if collectionView == feedsCollectionView {
            return monoclePosts.count + 1
        }
        return 0
    }
    //: MARK - Cell for Item At Collection VC
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == friendsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: friendsReuseIdentifier, for: indexPath) as! FriendsCell
            
            if indexPath.row == 0 { cell.imageView.image = UIImage(named: "add") }
            
            if monocleFriends.count != 0 && indexPath.row >= 1 {
                switch monocleFriends[indexPath.row - 1] {
                case .instagramUser(let user):
                    cell.imageView.downloadedFrom(link: user.image)
                case .twitterUser(let user):
                    cell.imageView.downloadedFrom(link: user.image)
                }
            }
                return cell
                
            
        } else if collectionView == segmentedControllerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuReuseIdentifier, for: indexPath) as! MenuCell
            cell.imageView.image = UIImage(named: menuImagesNames[indexPath.row])?.withRenderingMode(.alwaysTemplate)
            cell.imageView.contentMode = .scaleAspectFit
            cell.layer.cornerRadius = 10
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 1
            cell.backgroundColor = UIColor.lightText
            return cell
            
        } else if collectionView == feedsCollectionView {
            
            if monoclePosts.count != 0 {
                if indexPath.row == 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dateReuseIdentifier, for: indexPath) as! DateCell
                    cell.dateLabel.text = "July 27th"
                    cell.dayLabel.text = "Friday"
                    return cell
                } else {
                    
                    switch monoclePosts[indexPath.row - 1] {
                        
                    case .instagram(let value):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedReuseIdentifier, for: indexPath) as! FeedsCell
                        cell.media = value
                        return cell
                        
                    case .tweet(let value):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tweetReuseIdentifier, for: indexPath) as! TweetCell
                        cell.tweet = value
                        return cell
                    }
                }
            } else {
                // show do want to add ?
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: signInReuseIdentifier, for: indexPath) as! SignInCell
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: signInReuseIdentifier, for: indexPath) as! SignInCell
            return cell
        }
    }
    
    //: MARK -  DidSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFriend = monocleFriends[indexPath.row]
        switch collectionView {
        case friendsCollectionView:
            let cell = collectionView.cellForItem(at: indexPath) as! FriendsCell
            if indexPath.row == 0 {
                showFriendsSelectionVC()
            } else {
                checkAccountType(monocleUser: monocleFriends[indexPath.row - 1])
            }
            
        case segmentedControllerCollectionView:
            //checkAccountType(monocleUser: monocleFriends[indexPath.row])
            switch indexPath.row {
            case 0:
                print("MonocleTapped")
                
            case 1:
                print("TwitterTapped")
                getTweet(userID: "")
            case 2:
                print("InstagramTapped")
                monoclePosts.removeAll()
            case 3:
                print("MoreTapped")
            default:
                break
            }
        case feedsCollectionView:
            let cell = collectionView.cellForItem(at: indexPath) as! FeedsCell
            print("FeedsCell tapped at \(indexPath.row)")
        default:
            break
        }
    }
    // Mark: TO:DO
    func updateSegmentMenu(index: Int) {
        if index == 0 {
            // getMonoclePost()
        } else if index == 1 {
            getTweet(userID: "")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case friendsCollectionView:
            return Utility.shared.CGSizeMake(friendsCollectionView.frame.width/6, friendsCollectionView.frame.height)
        case segmentedControllerCollectionView:
            return CGSize(width: (view.frame.width / 4) - 10, height: 40)
        case feedsCollectionView:
            if indexPath.row == 0 {
                return CGSize(width: view.frame.width, height: 100)
            } else {
                return CGSize(width: view.frame.width - 40, height: 400)
            }
        default:
            return CGSize(width: 200, height: 400)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= 2 {
            
            cell.layer.shadowOpacity = 0
            
            UIView.animate(withDuration: 1.0) {
                cell.layer.shadowOpacity = 0.8
            }
        }
    }
    
    func setupDelegateForCollectionView() {
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        
        segmentedControllerCollectionView.delegate = self
        segmentedControllerCollectionView.dataSource = self
        
        feedsCollectionView.delegate = self
        feedsCollectionView.dataSource = self
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
            getUserTimeline(userID: value.uid)
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


