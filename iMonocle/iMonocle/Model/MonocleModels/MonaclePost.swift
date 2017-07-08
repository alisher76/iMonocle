//
//  MonacleType.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/13/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation

enum MonoclePost {
    
    case tweet(Tweet)
    case instagram(Media)
    
    init?(json: NSDictionary) {
        if let instaMedia = Media(json: json, accountType: "MonoclePost"){
            self = .instagram(instaMedia)
        }else if let tweet = Tweet(dictionary: json, postType: "tweet"){
            self = .tweet(tweet)
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






