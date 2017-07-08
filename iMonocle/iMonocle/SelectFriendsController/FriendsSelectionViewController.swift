//
//  FriendsSelectionViewController.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/7/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

private let reuseIdentifier = "FriendsCell"

class FriendsSelectionViewController: UICollectionViewController {
    
    fileprivate var friends = [MonocleUser]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    @IBOutlet var nextBUttonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriendsList()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return friends.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendsSelectionCell
        cell.monocleUser = friends[indexPath.row]
        return cell
    }
    
    func getFriendsList() {
        TwitterClient.sharedInstance?.getListOfFollowedFriends(success: { (_friends) in
            self.friends = _friends
            print(self.friends.count)
        }, failure: { (error) in
            print("Something went wrong, error is: \(error)")
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.allowsMultipleSelection = true
        
    }
}
