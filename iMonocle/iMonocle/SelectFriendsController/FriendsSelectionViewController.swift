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
    
    fileprivate var dataBaseHandle: DatabaseHandle? = nil
    fileprivate var databaseReference: DatabaseReference {
        return Database.database().reference()
    }
    fileprivate var friends = [MonocleUser]() {
        didSet {
           self.checkDataBase()
           collectionView?.reloadData()
        }
    }
    
    var index: IndexPath?
    var currentSelectedFriends = [String:MonocleUser]()
    
    @IBOutlet var nextBUttonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDataBase()
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
        if currentSelectedFriends[cell.twitterUser.screenName] != nil {
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.checkmarkImageView.image = UIImage(named: "Checked")
        }
        return cell
    }
    
    
    func getFriendsList() {
        TwitterClient.sharedInstance?.getListOfFollowedFriends(success: { (_friends) in
            self.friends = _friends
        }, failure: { (error) in
            print("Something went wrong, error is: \(error)")
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.allowsMultipleSelection = true
        let cell = collectionView.cellForItem(at: indexPath) as! FriendsSelectionCell
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.blue.cgColor
        cell.checkmarkImageView.image = UIImage(named: "Checked")
        FirebaseService.updateFriendsCollection(monocleUser: friends[indexPath.row])
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FriendsSelectionCell
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.checkmarkImageView.image = UIImage(named: "Unchecked")
        currentSelectedFriends.removeValue(forKey: cell.twitterUser.screenName)
        FirebaseService.removeFromFriendsList(monocleUser: friends[indexPath.row])
    }
    
    func checkDataBase() {
        guard let currentUser = Auth.auth().currentUser else {return}
        FirebaseService.rootRef.child(currentUser.uid).observe(.value) { (snapshot) in
            guard let snapValue = snapshot.value as? [String: [String:Any]] else {return}
            for (_, value) in snapValue {
                if let twitterUser = TwitterUser(dictionary: value, accountType: "Twitter") {
                    self.currentSelectedFriends[twitterUser.screenName] = MonocleUser.twitterUser(twitterUser)
                }else if let instagragUser = InstagramUser(json: value, accountType: "Instagram"){
                    self.currentSelectedFriends[instagragUser.userName] = MonocleUser.instagramUser(instagragUser)
                }
            }
        }
    }
}
