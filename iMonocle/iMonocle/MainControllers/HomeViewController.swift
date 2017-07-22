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

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let transition = PopAnimator()
    var index: IndexPath?
    var selectedImage: UIImageView?
    
    var monocleFriends = [MonocleUser]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    var monoclePosts = [MonoclePost]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return monoclePosts.count + 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuReuseIdentifier, for: indexPath) as! MenuViewControler
             return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
            cell.dayLabel.text = "Monday"
            cell.dateLabel.text = "June 6"
            return cell
        } else {
            switch monoclePosts[indexPath.row - 2] {
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
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: friendsReuseIdentifier, for: indexPath) as! FriendsCollecViewController
            headerCell.friends = monocleFriends
            headerCell.delegate = self
        return headerCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= 2 {
            index = indexPath
            let storyboard = UIStoryboard(name: "Starter", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            self.navigationController?.present(detailVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: view.frame.width, height: 60)
        } else if indexPath.row == 1 {
            return CGSize(width: view.frame.width - 30, height: 40)
        } else {
            return CGSize(width: view.frame.width - 40, height: 400)
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
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= 2 {
            
            cell.layer.shadowOpacity = 0
            
            UIView.animate(withDuration: 1.0) {
                cell.layer.shadowOpacity = 0.8
            }
        }
    }

}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        
        let selectedCell = collectionView?.cellForItem(at: index!) as! FeedsCell
        transition.originFrame = selectedCell.postImageView!.superview!.convert(selectedCell.postImageView!.frame, to: nil)
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let selectedCell = collectionView?.cellForItem(at: index!) as! FeedsCell
        transition.presenting = false
        selectedCell.postImageView!.isHidden = false
        return transition
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let cell = collectionView?.cellForItem(at: index!) as! FeedsCell
        coordinator.animate(
            alongsideTransition: { context in
                cell.postImageView.alpha = (size.width>size.height) ? 0.25 : 0.55
                self.collectionView?.reloadData()
        },
            completion: nil
        )
        
    }
}


