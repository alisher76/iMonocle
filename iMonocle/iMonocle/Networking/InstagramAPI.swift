//
//  InstagramAPI.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/22/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Instagram {
    
    let client_id = "ac00ba2a3ad64cc8b4a180dcc5869e49"
    
    // Turn friends list data into needed Type
    func populateFriendsList(_ data: Any?, callback: ([InstagramUser]) -> Void) {
        let json = JSON(data!)
        var users = [InstagramUser]()
        for _user in json["data"].arrayValue {
            let user = InstagramUser(fullName: _user["full_name"].stringValue, userName: _user["username"].stringValue, uid: _user["id"].stringValue, image: _user["profile_picture"].stringValue, accountType: "instagram")
            users.append(user)
        }
        callback(users)
    }
    
    //Get user lists data
    func fetchUserFriends(_ accessToken: String, callBack: @escaping ([InstagramUser]) -> Void) {
        request("https://api.instagram.com/v1/users/self/follows?access_token=\(accessToken)", method: .get).responseJSON { (responce) in
            self.populateFriendsList(responce.result.value, callback: callBack)
        }
    }
    // Get Monocle Converted list of friends
    func populateFriendsListMonacle(accessToken: String, callback: @escaping ([MonocolAccount]) -> Void) {
        
        request("https://api.instagram.com/v1/users/self/follows?access_token=\(accessToken)", method: .get).responseJSON { (responce) in
            
            var friendsInstaAccount: [[String:Any]] = []
            let list = JSON(responce.result.value!)
            for data in list["data"].arrayValue {
                
                let friendAccount: [String:Any] = ["fullName" : data["full_name"].stringValue, "userName" : data["username"].stringValue, "uid" : data["id"].stringValue, "image" : data["profile_picture"].stringValue, "accountType" : "instagram"]
                friendsInstaAccount.append(friendAccount)
            }
            guard let back = MonocolAccount.array(json: friendsInstaAccount) else {return}
            callback(back)
        }
    }
    
    // Turn media Data into needed type
    func populateFriendsRecentPosts(_ data: Any?, callback: ([Media]) -> Void) {
        
        let json = JSON(data!)
        var medias = [Media]()
        
        for _media in json["data"].arrayValue {
            var comments: [Comment] = []
            for comment in _media["comments"]["data"].arrayValue {
                comments.append(Comment(fromUserName: comment["from"]["username"].stringValue, text: comment["text"].stringValue))
            }
            
            medias.append(Media(takenPhoto: _media["images"]["standard_resolution"]["url"].stringValue, uid: _media["user"]["id"].stringValue, username: _media["user"]["username"].stringValue, avatarURL: _media["user"]["profile_picture"].stringValue, caption: _media["caption"]["text"].stringValue, comments: comments, time: _media["created_time"].intValue, likes: _media["item"]["count"].intValue, postType: "instaFeed"))
        }
        callback(medias)
    }
    
    // Get user media Data
    
    func fetchRecentMediaForUser(_ id: String, accessToken: String, callback: @escaping ([Media]) -> Void) {
        request("https://api.instagram.com/v1/users/\(id)/media/recent/?access_token=\(accessToken)", method: .get).responseJSON { (responce) in
            self.populateFriendsRecentPosts(responce.result.value, callback: callback)
        }
    }
    
    func fetchRecentLikesForUser(_ accessToken: String, callback: @escaping ([Media]) -> Void) {
        request("https://api.instagram.com/v1/users/self/media/liked?access_token=\(accessToken)", method: .get).responseJSON { (responce) in
            self.populateFriendsRecentPosts(responce.result.value, callback: callback)
        }
    }
    
    func fetchRecentMediaForUserMonocle(_ id: String, accessToken: String, callback: @escaping ([MonoclePost]) -> Void) {
        
        
        request("https://api.instagram.com/v1/users/\(id)/media/recent/?access_token=\(accessToken)", method: .get).responseJSON { (responce) in
            
            var posts: [NSDictionary] = []
            let media = JSON(responce.result.value!)
            for _media in media["data"].arrayValue {
                var comments: [Comment] = []
                for comment in _media["comments"]["data"].arrayValue {
                    comments.append(Comment(fromUserName: comment["from"]["username"].stringValue, text: comment["text"].stringValue))
                }
                
                let _posts: [String:Any] = ["takenPhoto" : _media["images"]["standard_resolution"]["url"].stringValue, "uid" : _media["user"]["id"].stringValue, "username": _media["user"]["username"].stringValue, "avatarURL" : _media["user"]["profile_picture"].stringValue, "caption" : _media["caption"]["text"].stringValue, "comments" : comments, "time" : _media["created_time"].intValue, "likes" : _media["item"]["count"].intValue, "postType" : "instaFeed"]
                posts.append(_posts as NSDictionary)
            }
            guard let back = MonoclePost.array(json: posts) else {
                print("Something went wrong")
                return
            }
            print(back)
            callback(back)
        }
        
    }
}
