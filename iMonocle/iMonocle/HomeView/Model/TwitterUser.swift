//
//  TwitterUser.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/5/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation


class TwitterUser {
    
    var name: String
    var uid: String
    var screenName: String
    var followerCount: Int
    var followingCount: Int
    var description: String
    var location: String
    var image: String
    var accountType: String
    
    init(name: String, uid: String, screenName: String, followerCount: Int, followingCount: Int, description: String, location: String, image: String, accountType: String) {
        self.name = name
        self.uid = uid
        self.screenName = screenName
        self.followerCount = followerCount
        self.followingCount = followingCount
        self.description = description
        self.location = location
        self.image = image
        self.accountType = accountType
    }
    
    convenience init?(json: NSDictionary, accountType: String?) {
        guard let name = json[TwitterUser.nameKey] as? String,
            let uid = json[TwitterUser.uidKey] as? String,
            let screenName = json[TwitterUser.screenNameKey] as? String,
            let followerCount = json[TwitterUser.followerCountKey] as? Int,
            let followingCount = json[TwitterUser.followingCounKey] as? Int,
            let description = json[TwitterUser.descriptionKey] as? String,
            let location = json[TwitterUser.locationKey] as? String,
            let image = json[TwitterUser.imageKey] as? String,
            let accountType = accountType
            else {
                return nil
        }
        self.init(name: name, uid: uid, screenName: screenName, followerCount: followerCount, followingCount: followingCount, description: description, location: location, image: image, accountType: accountType)
    }
    
    static func array(json: [NSDictionary], accountType: String = "twitter") -> [TwitterUser]? {
        var converted = [TwitterUser]()
        for i in json {
            guard let user = TwitterUser(json: i, accountType: accountType) else { return nil }
            converted.append(user)
        }
            return converted
        }
    
    static var nameKey: String = "name"
    static var uidKey: String = "id_str"
    static var screenNameKey: String = "screen_name"
    static var followerCountKey: String = "followers_count"
    static var followingCounKey: String =  "friends_count"
    static var descriptionKey: String = "description"
    static var locationKey: String = "location"
    static var imageKey: String = "profile_image_url_https"

}

