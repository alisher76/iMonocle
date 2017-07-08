//
//  MonocleUser.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/14/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation

enum MonocleUser {
    
    case twitterUser(TwitterUser)
    case instagramUser(InstagramUser)
    
    init?(json: NSDictionary) {
        if let instagram_User = InstagramUser(json: json, accountType: "Instagram") {
            self = .instagramUser(instagram_User)
        }else if let twitter_User = TwitterUser(dictionary: json, accountType: "Twitter") {
            self = .twitterUser(twitter_User)
        }else{
            return nil
        }
    }
    
    static func array(json: [NSDictionary]) -> [MonoclePost]? {
        
        var converted = [MonoclePost]()
        for feed in json {
            
            if let feedType = MonoclePost(json: feed){
                converted.append(feedType)
            }else{
                return nil
            }
        }
        return converted
    }
}


