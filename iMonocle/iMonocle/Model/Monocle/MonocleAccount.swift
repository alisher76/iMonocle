//
//  MonocleAccount.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/14/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation

enum MonocolAccount {
    
    case twitter(TwitterUser)
    case instagram(InstagramUser)
    
    init?(json: [String:Any]) {
        if let instaUser = InstagramUser(json: json, accountType: "instagram") {
            self = .instagram(instaUser)
        }else if let twitterUser = TwitterUser(dictionary: json, accountType: "twitter") {
            self = .twitter(twitterUser)
        }else{
            return nil
        }
    }
    
    static func array(json: [[String:Any]]) -> [MonocolAccount]? {
        
        var converted = [MonocolAccount]()
        for user in json {
            print(user)
            if let feedType = MonocolAccount(json: user){
                converted.append(feedType)
            }else{
                return nil
            }
        }
        return converted
    }
}
