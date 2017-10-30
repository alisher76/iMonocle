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
    
    // Mark: Number of rows
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
        
        if (indexPath.row == 0 && hasInstagramAccount) && (SavedStatus.instance.isLoggedInToInstagram && FirebaseService.instance.isCurrentUser(user: monocleFriendsArray[indexPath.row])) && (selectedOption == .monocle || selectedOption == .instagram) {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "postsCell", for: indexPath) as? PostsCell else { return UITableViewCell() }
            cell.delegate = self
            cell.monoclePosts = monoclePosts
            cell.animateInstaCell()
            return cell
            
        } else if selectedOption == .monocle || selectedOption == .twitter {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tweetsCell", for: indexPath) as? TweetCell else { return UITableViewCell() }
            
            if hasInstagramAccount && selectedOption == .monocle {
                cell.rowNumber = indexPath.row - 1
                switch monocleTweets[indexPath.row - 1] {
                case .tweet(let tweet):
                    if !indexNumbersForAnimatedTweetsCell.contains(indexPath.row) {
                        cell.animateTweetCell()
                        indexNumbersForAnimatedTweetsCell.append(indexPath.row)
                    }
                    cell.delegate = self
                    cell.setUp(tweet: tweet)
                default: break
                }
            } else {
                cell.rowNumber = indexPath.row
                switch monocleTweets[indexPath.row] {
                case .tweet(let tweet):
                    if !indexNumbersForAnimatedTweetsCell.contains(indexPath.row - 1) {
                        cell.animateTweetCell()
                        indexNumbersForAnimatedTweetsCell.append(indexPath.row)
                    }
                    cell.delegate = self
                    cell.setUp(tweet: tweet)
                default: break
                }
            }
            return cell
        } else if selectedOption == .instagram && (FirebaseService.instance.isCurrentUser(user: monocleFriendsArray[indexPath.row]) || !hasInstagramAccount) {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addAccountCell", for: indexPath) as? AddMonocleAccountCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 && hasInstagramAccount && selectedOption == .monocle || selectedOption == .instagram {
            return CGFloat(self.view.frame.size.height / 1.5)
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
        if collectionView == friendsCollectionView {
            if monocleFriendsArray.count > 0 {
                return monocleFriendsArray.count
            } else {
                return 0
            }
        } else {
            return 4
        }
    }
    
    // MARK: Cell for item at
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == friendsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsCell", for: indexPath) as? FriendsListCell else {
                return UICollectionViewCell()
            }
            cell.setupCell(friend: monocleFriendsArray[indexPath.row])
            if !indexNumbersForAnimatedFriendsCell.contains(indexPath.row) {
                cell.animateFriendsCell()
                indexNumbersForAnimatedFriendsCell.append(indexPath.row)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "segmentCollectionViewCell", for: indexPath) as! SegmentMenuCollectionViewCell
            cell.tintColor = UIColor.white
            cell.setup(name: segmentMenuImages[indexPath.row])
            cell.animateSegmentCell()
            return cell
        }
    }

    // MARK: Size for item at
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == friendsCollectionView {
            return CGSize(width: view.frame.size.width / 8, height: view.frame.size.width / 8)
        } else {
            return CGSize(width: (view.frame.size.width / 4) - 10, height: 30)
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
        } else if collectionView == segmentCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "segmentCollectionViewCell", for: indexPath) as! SegmentMenuCollectionViewCell
           // cell.delegate = self
            cell.layer.shadowOpacity = 0
            cell.segmentImage.layer.opacity = 0.5
            switch indexPath.row {
            case 0:
                self.selectedOption = .monocle
                cell.segmentImage.image = UIImage(named: selectedMenu[indexPath.row])
            case 1:
                self.selectedOption = .twitter
                cell.segmentImage.image = UIImage(named: selectedMenu[indexPath.row])
            case 2:
                self.selectedOption = .instagram
                cell.segmentImage.image = UIImage(named: selectedMenu[indexPath.row])
            case 3:
                self.selectedOption = .more
                cell.segmentImage.image = UIImage(named: selectedMenu[indexPath.row])
            default:
                self.selectedOption = .monocle
                cell.segmentImage.image = UIImage(named: selectedMenu[indexPath.row])
            }
            cell.segmentImage.image = UIImage(named: segmentMenuImages[indexPath.row])
            cell.animateSegmentCell()
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
