//
//  HomeVC.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 8/28/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import Alamofire

enum SegmentOptions: String {
    case monocle, twitter, instagram, more
}

class HomeVC: UIViewController {

    // Outlets:
    @IBOutlet weak var pleaseLoginSign: UILabel!
    @IBOutlet weak var composeBtn: UIButton!
    @IBOutlet weak var topImageView: CircleImage!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet var segmentCollectionView: UICollectionView!
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    @IBOutlet var mainTableView: UITableView!
    
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var friendsCollectionViewTopConstraint: NSLayoutConstraint!
    
    // Variables:
    var cellHeight: CGFloat?
    var isOpen: Bool = false
    var hasInstagramAccount: Bool = false {
        didSet {
            mainTableView.reloadData()
        }
    }
    
    var segmentMenuImages = ["Monocle", "twitter", "Instagram", "More-1"]
    var indexNumbersForAnimatedTweetsCell: [Int] = []
    var indexNumbersForAnimatedFriendsCell: [Int] = []
    
    let transition = CircularTransaction()
    var selectedFriend = FirebaseService.instance.selectedUser {
        didSet {
            if selectedFriend != nil {
             selectedFriendDidChange()
            }
        }
    }
    var monocleFriendsArray = [MonocleUser]() {
        didSet {
            selectedFriend = monocleFriendsArray.first
        }
    }
    var monocleTweets = [MonoclePost]() {
        didSet {
            indexNumbersForAnimatedTweetsCell.removeAll()
        }
    }
    var monoclePosts = [MonoclePost]() {
        didSet {
            print(monoclePosts.count)
            indexNumbersForAnimatedTweetsCell.removeAll()
        }
    }
    var selectedOption = SegmentOptions.monocle {
        didSet {
            segmentMenuDidChange(to: selectedOption)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.userDataDidChange), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        revealViewController().rightViewRevealWidth = self.view.frame.width - 100
        addButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)), for: .touchUpInside)
        
        topImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAccountInfo)))
        topImageView.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SavedStatus.instance.isLoggedIn {
            checkDataBase()
        }
    }
    
    @objc func showAccountInfo() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let accounInfoVC = storyboard.instantiateViewController(withIdentifier: StoryboardIdentifier.accountInfoVC.rawValue) as! AccountInfoVC
        accounInfoVC.transitioningDelegate = self
        accounInfoVC.modalPresentationStyle = .custom
        
        self.present(accounInfoVC, animated: true, completion: nil)
    }
    
    

    fileprivate func selectedFriendDidChange() {
        if SavedStatus.instance.isLoggedIn {
            switch selectedFriend! {
            case .twitterUser(let tUser):
                TwitterClient.sharedInstance?.getUserTimeline(userID: tUser.uid, success: { (monoTweet) in
                    self.monocleTweets = monoTweet
                    self.mainTableView.reloadData()
                }, failure: { (error) in
                    print(error.localizedDescription)
                })
                self.topImageView.downloadedFrom(link: tUser.image)
                
            case .instagramUser(let iUser):
                self.topImageView.downloadedFrom(link: iUser.image)
            }
            
            if FirebaseService.instance.isCurrentUser(user: self.selectedFriend!) && SavedStatus.instance.isLoggedInToInstagram {
                Instagram.instance.fetchRecentMediaForUser(SavedStatus.instance.currentUserInstagramID, accessToken: SavedStatus.instance.instagramAuthToken, callback: { (posts) in
                    self.monoclePosts = posts
                    self.hasInstagramAccount = true
                })
                
            } else {
                FirebaseService.instance.hasInstagramAccount(monocleUser: selectedFriend!, endPoint: "friends") { (hasAccount) in
                    if hasAccount {
                        Instagram.instance.fetchRecentMonoclePostsForUser(FirebaseService.instance.selectedUserInstagramID!, accessToken: SavedStatus.instance.instagramAuthToken, callback: { (recentPosts) in
                            self.monoclePosts = recentPosts
                            self.hasInstagramAccount = hasAccount
                        })
                    } else {
                        self.hasInstagramAccount = false
                        self.monoclePosts.removeAll()
                    }
                }
            }
        }
    }
    
    func setDelegate() {
        
        segmentCollectionView.delegate = self
        segmentCollectionView.dataSource = self
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = UITableViewAutomaticDimension
        mainTableView.estimatedRowHeight = 140
    }
    
    // MARK: Segment Menu
    fileprivate func segmentMenuDidChange(to option: SegmentOptions) {
        switch option {
        case .monocle:
            mainTableView.reloadData()
        case .twitter:
            mainTableView.reloadData()
        case .instagram:
            mainTableView.reloadData()
        case .more:
            print("more")
        }
    }
    
    func checkDataBase() {
        if SavedStatus.instance.isLoggedIn {
            self.pleaseLoginSign.alpha = 0.0
            FirebaseService.instance.currentUserAccount { (user) in
                FirebaseService.instance.currentListOfFriends { (users) in
                    self.monocleFriendsArray.removeAll()
                    self.monocleFriendsArray = user
                    for (_,friend) in users {
                        self.monocleFriendsArray.append(friend)
                    }
                    OperationQueue.main.addOperation {
                        FirebaseService.instance.selectedUser = self.monocleFriendsArray.first!
                        self.friendsCollectionView.reloadData()
                    }
                }
            }
        } else {
            self.pleaseLoginSign.alpha = 1.0
            self.monocleFriendsArray.removeAll()
            self.monoclePosts.removeAll()
            self.monocleTweets.removeAll()
            self.topImageView.image = UIImage(named: "profile-icon")
        }
    }
    
    @objc func userDataDidChange() {
        checkDataBase()
        friendsCollectionView.reloadData()
    }
    
    
    @IBAction func moreBtnTapped(_ sender: Any) {
        isOpen = !isOpen
        menuHeightConstraint.constant = isOpen ? 140.0 : 90.0
        friendsCollectionViewTopConstraint.constant = isOpen ? 80.0 : 30.0
        segmentCollectionView.reloadData()
    }
    
    
}


extension HomeVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = topImageView.center
        transition.circleColor = topImageView.backgroundColor!
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = topImageView.center
        transition.circleColor = topImageView.backgroundColor!
        
        return transition
    }
    
    
}

