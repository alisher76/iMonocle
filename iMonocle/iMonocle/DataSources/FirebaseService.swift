//
//  FirebaseService.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/10/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Firebase
import Foundation

class FirebaseService {
    
    static let rootRef = Database.database().reference().child("users")
    static let currentuserID = Auth.auth().currentUser?.uid
    static var selectedUser: MonocleUser?
    
    static func sigIn(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if Auth.auth().currentUser?.email == email && error != nil {
                print("Successfully logged in")
            }else{
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if error != nil {
                        print("Created account")
                    }
                }
            }
        }
    }
    
    static func updateFriendsCollection(monocleUser: MonocleUser) {
        
        var back: [String:Any] = [:]
        // var instagramUser: InstagramUser!
        
        switch monocleUser {
        case .instagramUser(let value):
            // instagramUser = value
            print(value)
        case .twitterUser(let twitterUser):
            let data: [String: Any] = [ "name":"\(twitterUser.name)",
                "id_str":"\(twitterUser.uid)",
                "screen_name":"\(twitterUser.screenName)",
                "followers_count":"\(twitterUser.followerCount)",
                "friends_count":"\(twitterUser.followingCount)",
                "description":"\(twitterUser.description)",
                "location":"\(twitterUser.location)",
                "profile_image_url_https":"\(twitterUser.image)"]
            back = data
            FirebaseService.rootRef.child(currentuserID!).child(twitterUser.screenName).setValue(back)
        }
        
    }
    
    static func checkExistingFriendAccounts(monocleUser: MonocleUser) -> Bool {
        switch monocleUser {
        case .instagramUser(let value):
            // instagramUser = value
            print(value)
            return false
        case .twitterUser(let twitterUser):
            FirebaseService.rootRef.child(currentuserID!).child(twitterUser.screenName).observe(.value, with: { (snapShot) in
            return (snapShot.hasChild("instagram"))
            })
        }
        return false
    }
    
    static func removeFromFriendsList(monocleUser: MonocleUser) {
        
        switch monocleUser {
        case .instagramUser(let value):
            // instagramUser = value
            print(value)
        case .twitterUser(let twitterUser):
            FirebaseService.rootRef.child(currentuserID!).child(twitterUser.screenName).removeValue()
        }
    }
    
    static func currentListOfFriends(success: @escaping ([String: MonocleUser]) -> ()) {
        var back: [String: MonocleUser] = [:]
        guard let currentUser = Auth.auth().currentUser else {return}
        FirebaseService.rootRef.child(currentUser.uid).observe(.value) { (snapshot) in
            guard let snapValue = snapshot.value as? [String: [String:Any]] else {return}
            for (_, value) in snapValue {
                if let twitterUser = TwitterUser(dictionary: value, accountType: "Twitter") {
                    back[twitterUser.screenName] = MonocleUser.twitterUser(twitterUser)
                }else if let instagragUser = InstagramUser(json: value, accountType: "Instagram"){
                    back[instagragUser.userName] = MonocleUser.instagramUser(instagragUser)
                }
            }
            success(back)
        }
    }
    
    
}
