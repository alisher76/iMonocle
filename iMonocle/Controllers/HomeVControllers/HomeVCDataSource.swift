//
//  HomeVCDataSource.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 8/28/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import Alamofire

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SavedStatus.instance.isLoggedIn {
        if selectedOption == .monocle {
            if SavedStatus.instance.isLoggedInToInstagram {
                if monocleFriendsArray.first != nil {
                    if hasInstagramAccount || FirebaseService.instance.isCurrentUser(user: monocleFriendsArray.first!) {
                        return monocleTweets.count + 1
                    }
                }
            } else {
                return monocleTweets.count
            }
        } else if selectedOption == .twitter {
            return monocleTweets.count
        } else {
            return 2
        }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "segmentCell", for: indexPath) as? SegmentCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        } else if (indexPath.row == 1 && hasInstagramAccount) && (SavedStatus.instance.isLoggedInToInstagram && FirebaseService.instance.isCurrentUser(user: monocleFriendsArray[indexPath.row - 1])) && (selectedOption == .monocle || selectedOption == .instagram) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "postsCell", for: indexPath) as? PostsCell else { return UITableViewCell() }
            cell.delegate = self
            cell.monoclePosts = monoclePosts
            cell.animateInstaCell()
            return cell
        } else if selectedOption == .monocle || selectedOption == .twitter {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tweetsCell", for: indexPath) as? TweetCell else { return UITableViewCell() }
            if hasInstagramAccount {
                cell.rowNumber = indexPath.row - 2
                switch monocleTweets[indexPath.row - 2] {
                case .tweet(let tweet):
                    if !indexNumbersForAnimatedCell.contains(indexPath.row) {
                        cell.animateTweetCell()
                    }
                    cell.delegate = self
                    cell.setUp(tweet: tweet)
                default: break
                }
            } else {
                cell.rowNumber = indexPath.row - 1
                switch monocleTweets[indexPath.row - 1] {
                case .tweet(let tweet):
                    if !indexNumbersForAnimatedCell.contains(indexPath.row) {
                        cell.animateTweetCell()
                    }
                    cell.delegate = self
                    cell.setUp(tweet: tweet)
                default: break
                }
            }
            return cell
        } else if selectedOption == .more {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addAccountCell", for: indexPath) as? AddMonocleAccountCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        } else if selectedOption == .instagram && (FirebaseService.instance.isCurrentUser(user: monocleFriendsArray[indexPath.row - 1]) || !hasInstagramAccount) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addAccountCell", for: indexPath) as? AddMonocleAccountCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return  CGFloat(60)
        }
        else if indexPath.row == 1 && hasInstagramAccount && selectedOption == .monocle || selectedOption == .instagram {
            
            if isOpen {
                return CGFloat(self.view.frame.size.height / 1.5)
            } else {
                return CGFloat(self.view.frame.size.height / 2)
            }
            
        } else {
            return UITableViewAutomaticDimension
        }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if monocleFriendsArray.count > 0 {
                return monocleFriendsArray.count
            } else {
                return 0
            }
    }
    
    // MARK: Cell for item at
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == friendsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsCell", for: indexPath) as? FriendsListCell else {
                return UICollectionViewCell()
            }
            cell.setupCell(friend: monocleFriendsArray[indexPath.row])
            cell.animateFriendsCell()
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    
    // MARK: Size for item at
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == friendsCollectionView {
            return CGSize(width: view.frame.size.width / 8, height: view.frame.size.width / 8)
        } else {
            return CGSize(width: 200, height: 200)
        }
    }
    
    
    
    // MARK: Minimum line spacing
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == friendsCollectionView {
            return 5.0
        } else {
            return 10.0
        }
    }
    
    
    // MARK: Did select item at
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == friendsCollectionView {
            FirebaseService.instance.selectedUser = monocleFriendsArray[indexPath.row]
            selectedFriend = monocleFriendsArray[indexPath.row]
        }
    }
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (velocity.y > 0 ) {
            
        } else {
            
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 5)
        } else {
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
    }
}



extension HomeVC: MosaicLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        let random = arc4random_uniform(4) + 1
        return CGFloat(random * 100)
    }
}
