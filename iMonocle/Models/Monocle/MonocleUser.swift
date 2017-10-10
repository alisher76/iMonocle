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
        if let instagram_User = InstagramUser(json: json, accountType: "instagram") {
            self = .instagramUser(instagram_User)
        } else if let twitter_User = TwitterUser(dictionary: json, accountType: "twitter") {
            self = .twitterUser(twitter_User)
        }else{
            return nil
        }
    }

    init?(snapshot: DataSnapshot) {
        let snapValue = snapshot.value as! [String: Any]
        if let instagram_User = InstagramUser(json: snapValue, accountType: "instagram") {
            self = .instagramUser(instagram_User)
        } else {
            let twitter_User = TwitterUser(snapshot: snapshot, account: "twitter")
            self = .twitterUser(twitter_User)
        }
    }
    
    static func array(json: [[String:Any]]) -> [MonocleUser]? {
        
        var converted = [MonocleUser]()
        for user in json {
            if let feedType = MonocleUser(json: user){
                converted.append(feedType)
            }else{
                return nil
            }
        }
        return converted
    }
    
    static func returnConvertedType(input: MonocleUser) -> Any {
        switch input {
        case .instagramUser(let instaUser):
            return instaUser
        case .twitterUser(let twitterUser):
            return twitterUser
        }
    }
    
}

