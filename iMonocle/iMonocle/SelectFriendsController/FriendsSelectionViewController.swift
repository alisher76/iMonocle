//
//  FriendsSelectionViewController.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/7/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import Firebase

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

        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                // user logged in already
                self.getFriendsList()
                print("User Logged in already")
            } else {
                self.performSegue(withIdentifier: "SignIn", sender: self)
            }
        }
        
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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
