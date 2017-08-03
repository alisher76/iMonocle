//
//  HomeViewExtentions.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/29/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //: MARK - Number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    //: MARK - NumberOfItems Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == friendsCollectionView {
            return monocleUsersStore.monocleUsers.count + 1
        } else if collectionView == segmentedControllerCollectionView {
            return 4
        } else if collectionView == feedsCollectionView {
            return monoclePostsStore.monoclePosts.count + 1
        }
        return 0
    }
    
    //: MARK - Cell for Item At Collection VC
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == friendsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardIdentifier.friendsReuseIdentifier.rawValue, for: indexPath) as! FriendsCell
            if indexPath.row == 0 { cell.imageView.image = UIImage(named: "add") }
            
            if monocleUsersStore.monocleUsers.count != 0 && indexPath.row >= 1 {
                switch monocleUsersStore.monocleUsers[indexPath.row - 1] {
                case .instagramUser(let user):
                    cell.imageView.downloadedFrom(link: user.image)
                case .twitterUser(let user):
                    cell.imageView.downloadedFrom(link: user.image)
                }
            }
            return cell
            
            
        } else if collectionView == segmentedControllerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardIdentifier.menuReuseIdentifier.rawValue, for: indexPath) as! MenuCell
            cell.imageView.image = UIImage(named: menuImagesNames[indexPath.row])?.withRenderingMode(.alwaysTemplate)
            cell.imageView.contentMode = .scaleAspectFit
            cell.layer.cornerRadius = 10
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 1
            cell.backgroundColor = UIColor.lightText
            return cell
            
        } else if collectionView == feedsCollectionView {
            
            if monoclePostsStore.monoclePosts.count != 0 {
                if indexPath.row == 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardIdentifier.dateReuseIdentifier.rawValue, for: indexPath) as! DateCell
                    cell.dateLabel.text = "July 27th"
                    cell.dayLabel.text = "Friday"
                    return cell
                } else {
                    
                    switch monoclePostsStore.monoclePosts[indexPath.row - 1] {
                        
                    case .instagram(let value):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardIdentifier.feedReuseIdentifier.rawValue, for: indexPath) as! FeedsCell
                        cell.media = value
                        return cell
                        
                    case .tweet(let value):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardIdentifier.tweetReuseIdentifier.rawValue, for: indexPath) as! TweetCell
                        cell.tweet = value
                        return cell
                    }
                }
            } else {
                // show do you want to add account?
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardIdentifier.signInReuseIdentifier.rawValue, for: indexPath) as! SignInCell
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardIdentifier.signInReuseIdentifier.rawValue, for: indexPath) as! SignInCell
            return cell
        }
    }
    
    // MARK: SizeForItemAt
    
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row >= 2 {
            
            cell.layer.shadowOpacity = 0
            
            UIView.animate(withDuration: 1.0) {
                cell.layer.shadowOpacity = 0.8
            }
        }
    }
    
}
