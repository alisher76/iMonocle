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
    
    static func removeFromFriendsList(monocleUser: MonocleUser) {
        switch monocleUser {
        case .instagramUser(let value):
            // instagramUser = value
            print(value)
        case .twitterUser(let twitterUser):
            FirebaseService.rootRef.child(currentuserID!).child(twitterUser.screenName).removeValue()
        }
    }
}
