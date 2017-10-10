//
//  TwitterUser.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/5/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation
import Firebase

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
    var firebaseRef: DatabaseReference?
    
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
    
    convenience init?(dictionary: [String:Any], accountType: String?) {
        guard let name = dictionary[TwitterUser.nameKey] as? String,
            let uid = dictionary[TwitterUser.uidKey] as? String,
            let screenName = dictionary[TwitterUser.screenNameKey] as? String,
            let description = dictionary[TwitterUser.descriptionKey] as? String,
            let location = dictionary[TwitterUser.locationKey] as? String,
            let image = dictionary[TwitterUser.imageKey] as? String,
            let accountType = accountType
            else {
                return nil
        }
        let followerCount = 1
        let followingCount = 1
        self.init(name: name, uid: uid, screenName: screenName, followerCount: followerCount, followingCount: followingCount, description: description, location: location, image: image, accountType: accountType)
    }
    
    init(snapshot: DataSnapshot, account: String) {
            let snapValue = snapshot.value as! [String: Any]
            let dictioanry = snapValue["twitter"] as! [String: Any]
            name = dictioanry[TwitterUser.nameKey] as! String
            uid = dictioanry[TwitterUser.uidKey] as! String
            screenName = dictioanry[TwitterUser.screenNameKey] as! String
            description = dictioanry[TwitterUser.descriptionKey] as! String
            location = dictioanry[TwitterUser.locationKey] as! String
            image = dictioanry[TwitterUser.imageKey] as! String
            accountType = account
            firebaseRef = snapshot.ref
            followerCount = 1
            followingCount = 1
    }
    
    static func array(json: [[String:Any]], accountType: String = "twitter") -> [TwitterUser]? {
        var converted = [TwitterUser]()
        for i in json {
            guard let user = TwitterUser(dictionary: i, accountType: accountType) else { return nil }
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

