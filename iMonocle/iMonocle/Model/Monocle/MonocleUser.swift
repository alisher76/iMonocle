//
//  MonocleUser.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/14/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation
import Firebase

enum MonocleUser {
    
    case twitterUser(TwitterUser)
    case instagramUser(InstagramUser)
    
    init?(json: [String:Any]) {
        if let instagram_User = InstagramUser(json: json, accountType: "Instagram") {
            self = .instagramUser(instagram_User)
        }else if let twitter_User = TwitterUser(dictionary: json, accountType: "Twitter") {
            self = .twitterUser(twitter_User)
        }else{
            return nil
        }
    }
    
    func returnConvertedUser(monocleUser: MonocleUser) -> (instagram: InstagramUser?, twitter: TwitterUser?) {
        
        switch monocleUser {
        case .instagramUser(let user):
            return (instagram: user, twitter: nil)
        case .twitterUser(let user):
            return (instagram: nil, twitter: user)
        }
    }
    
    static func array(json: [[String:Any]]) -> [MonocleUser]? {
        
        var converted = [MonocleUser]()
        for user in json {
            print(user)
            if let feedType = MonocleUser(json: user){
                converted.append(feedType)
            }else{
                return nil
            }
        }
        return converted
    }
    
}

class MonocleUserStore {
    
    var delegate: HomeViewController?
    
    var monocleUsers = [MonocleUser]() {
        didSet {
            delegate?.friendsCollectionView.reloadData()
            FirebaseService.selectedUser = monocleUsers.first
        }
    }
    
    func getCurrentListOfFriends() {
        FirebaseService.currentListOfFriends { (users) in
            for (_,value) in users {
                self.monocleUsers.append(value)
            }
        }
    }
    
}

