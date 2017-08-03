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
    var monoclePostsStore: MonoclePostStore!
    var monocleUsersStore: MonocleUserStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monocleUsersStore.monocleUsers.removeAll()
        monocleUsersStore.getCurrentListOfFriends()
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
                monoclePostsStore.checkAccount(monocleUser: monocleUsersStore.monocleUsers[indexPath.row - 1])
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
        case 2:
            print("InstagramTapped")
        case 3:
            print("MoreTapped")
        default:
            break
        }
    }
    
    @objc func handleMenu() {
        print("HandleMenu")
    }
    
    
    func showFriendsSelectionVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FriendsSelectionVC") as! FriendsSelectionViewController
        self.show(vc, sender: self)
    }
    
    func setupDelegate() {
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        
        segmentedControllerCollectionView.delegate = self
        segmentedControllerCollectionView.dataSource = self
        
        feedsCollectionView.delegate = self
        feedsCollectionView.dataSource = self
        
        monoclePostsStore.delegate = self
        monocleUsersStore.delegate = self
        
        Instagram().delegate = self
    }
    
    func instagramSignIn() {
        let userDefault = UserDefaults.standard
        let accessToken = userDefault.object(forKey: "instagramAccessToken") as? String
        if accessToken != nil {
            // show do you want to sign in?
            // delegate?.monoclePosts.removeAll()
        }
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


