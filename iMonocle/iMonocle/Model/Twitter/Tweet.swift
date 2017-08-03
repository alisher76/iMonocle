//
//  Tweet.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/4/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

private var userRef: [String:Any]?
private var entitiesRef: [String:Any]?

class Tweet {
    
    
    var tweetID: Int!
    var screenName: String?
    var author: String?
    var authorProfilePic: URL?
    var text: String?
    var timestamp: Date?
    var favoriteCount: Int = 0
    var retweetsCount: Int = 0
    var urls: [[String:Any]]?
    var media: [[String:Any]]?
    var postType: String
    
    var precedingTweetID: Int?
    
    var retweeted: Bool {
        didSet {
            if retweeted {
                retweetsCount += 1
            }else{
                retweetsCount -= 1
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
    
    init?(dictionary: [String:Any], postType: String) {
        
        precedingTweetID = dictionary[Tweet.precedingTweetIDKey] as? Int
        userRef = dictionary[Tweet.userRefKey] as? [String:Any]
        tweetID = dictionary[Tweet.tweetIDKey] as! Int
        screenName = userRef?[Tweet.screenNameKey]! as? String
        entitiesRef = dictionary[Tweet.entitiesRefKey] as? [String:Any]
        media = entitiesRef?[Tweet.mediaKey] as? [[String:Any]]
        urls = entitiesRef?[Tweet.urlsKey] as? [[String:Any]]
        author = userRef?[Tweet.authorNameKey] as? String
        authorProfilePic = URL(string: (userRef?[Tweet.authorProfilePicKey] as! String).replacingOccurrences(of: "normal.png", with: "bigger.png", options: .literal, range: nil))
        
        text = dictionary[Tweet.textKey] as? String
        retweetsCount = dictionary[Tweet.retweetsKey] as? Int ?? 0
        favoriteCount = dictionary[Tweet.favoritedKey] as? Int ?? 0
        
        retweeted = (dictionary["retweeted"] as? Bool ?? false)
        favorited = (dictionary["favorited"] as? Bool ?? false)
        
        let timestampString = dictionary[Tweet.timestampKey] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
        self.postType = postType
        
    }
    
    class func tweetWithArray(dictionaries: [[String:Any]], postType: String = "tweet") -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary, postType: postType)
            tweets.append(tweet!)
        }
        
        return tweets
    }
    static var precedingTweetIDKey: String = "in_reply_to_status_id"
    static var userRefKey: String = "user"
    static var tweetIDKey: String = "id"
    static var screenNameKey: String = "screen_name"
    static var entitiesRefKey: String =  "entities"
    static var mediaKey: String = "media"
    static var urlsKey: String = "urls"
    static var authorNameKey: String = "name"
    static var authorProfilePicKey: String = "profile_image_url_https"
    static var textKey: String = "text"
    static var retweetsKey: String = "retweet_count"
    static var favoritedKey: String = "favorite_count"
    static var timestampKey: String = "created_at"
}

