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
    var monoclePosts = [MonoclePost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
         return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuReuseIdentifier, for: indexPath) as! MenuViewControler
        return cell
        
//        if indexPath.row == 0 {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuReuseIdentifier, for: indexPath) as! MenuViewControler
//             return cell
//        } else if indexPath.row == 1 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
//            cell.dayLabel.text = "Monday"
//            cell.dateLabel.text = "June 6"
//            return cell
//        } else {
//            switch monoclePosts[indexPath.row] {
//            case .instagram(let value):
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedReuseIdentifier, for: indexPath) as! FeedsCell
//                cell.media = value
//                return cell
//            case .tweet(let value):
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedReuseIdentifier, for: indexPath) as! TweetCell
//                cell.tweet = value
//                return cell
//            }
//        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: friendsReuseIdentifier, for: indexPath) as! FriendsCollecViewController
            headerCell.friends = monocleFriends
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
            alongsideTransition: {context in
                cell.postImageView.alpha = (size.width>size.height) ? 0.25 : 0.55
                self.collectionView?.reloadData()
        },
            completion: nil
        )
        
    }
}


