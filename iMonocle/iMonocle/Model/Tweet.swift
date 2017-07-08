//
//  Tweet.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/4/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation

private var userRef: [String:Any]?
private var entitiesRef: [String:Any]?
private var userEntitiesRef: [String:Any]?

class Tweet {
    
    
    var tweetID: Int!
    var screenName: String?
    var author: String?
    var authorProfilePic: URL?
    var text: String?
    //    var timeStamp: Date?
    var favoriteCount: Int = 0
    var retweetsCount: Int = 0
    var urls: [NSDictionary]?
    var media: [NSDictionary]?
    var postType: String
    
    var precedingTweetID: Int?
    
    var retweeted: Bool {
        didSet {
            if retweeted {
                retweetsCount += 1
            }else{                retweetsCount -= 1
            }
        }
    }
    var favorited: Bool {
        didSet {
            if favorited {
                favoriteCount += 1
            }else{
                favoriteCount -= 1
            }
        }
    }
    
    init?(dictionary: NSDictionary, postType: String) {
        
        precedingTweetID = dictionary["in_reply_to_status_id"] as? Int
        userRef = dictionary["user"] as? [String:Any]
        tweetID = dictionary["id"] as! Int
        screenName = userRef?["screen_name"]! as? String
        entitiesRef = dictionary["entities"] as? [String:Any]
        media = entitiesRef?["media"] as? [NSDictionary]
        userEntitiesRef = userRef?["entities"] as? [String:Any]
        urls = entitiesRef?["urls"] as? [NSDictionary]
        author = userRef?["name"] as? String
        authorProfilePic = URL(string: (userRef?["profile_image_url_https"] as! String).replacingOccurrences(of: "normal.png", with: "bigger.png", options: .literal, range: nil))
        
        text = dictionary["text"] as? String
        retweetsCount = dictionary["retweet_count"] as? Int ?? 0
        favoriteCount = dictionary["favorite_count"] as? Int ?? 0
        
        retweeted = (dictionary["retweeted"] as? Bool ?? false)
        favorited = (dictionary["favorited"] as? Bool ?? false)
        self.postType = postType
        
    }
    
    class func tweetWithArray(dictionaries: [NSDictionary], postType: String = "tweet") -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary, postType: postType)
            tweets.append(tweet!)
        }
        
        return tweets
    }
    
    
}

