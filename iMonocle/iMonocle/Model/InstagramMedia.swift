//
//  InstagramMedia.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/13/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

var sJSON: JSON!

class Media {
    
    var takenPhoto: String
    var uid: String
    var username: String
    var avatarURL: String
    var caption: String
    var comments: [Comment]
    var time: Int
    var likes: Int
    var postType: String
    
    init(takenPhoto: String, uid: String, username: String, avatarURL: String, caption: String, comments: [Comment], time: Int, likes: Int, postType: String) {
        self.takenPhoto = takenPhoto
        self.uid = uid
        self.username = username
        self.avatarURL = avatarURL
        self.caption = caption
        self.comments = comments
        self.time = time
        self.likes = likes
        self.postType = postType
    }
    
    convenience init?(json: NSDictionary, accountType: String?) {
        guard let takenPhoto = json[Media.takenPhotoKey] as? String,
            let uid = json[Media.uidKey] as? String,
            let username = json[Media.usernameKey] as? String,
            let avatarURL = json[Media.avatarURLKEY] as? String,
            let caption = json[Media.captionKey] as? String,
            let time = json[Media.timeKey] as? Int,
            let likes = json[Media.likes] as? Int,
            let postType = json[Media.postTypeKey] as? String
            else {
                return nil
        }
        sJSON = JSON(json)
        var comments: [Comment] = []
        for _media in sJSON["data"].arrayValue {
            for comment in _media["comments"]["data"].arrayValue {
                comments.append(Comment(fromUserName: comment["from"]["username"].stringValue, text: comment["text"].stringValue))
            }
        }
            self.init(takenPhoto: takenPhoto, uid: uid, username: username, avatarURL: avatarURL, caption: caption, comments: comments, time: time, likes: likes, postType: postType)
        
    }

static func array(json: [NSDictionary], accountType: String = "twitter") -> [TwitterUser]? {
    var converted = [TwitterUser]()
    for i in json {
        guard let user = TwitterUser(json: i, accountType: accountType) else { return nil }
        converted.append(user)
    }
    return converted
}
    
    static var takenPhotoKey: String = "takenPhoto"
    static var uidKey: String = "uid"
    static var usernameKey: String = "username"
    static var avatarURLKEY: String = "avatarURL"
    static var captionKey: String =  "caption"
    static var commentsKey: String = "comments"
    static var timeKey: String = "time"
    static var likes: String = "likes"
    static var postTypeKey: String = "postType"
}


