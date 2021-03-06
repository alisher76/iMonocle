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
    
    init?(json: [String:Any]) {
        if let instaMedia = Media(json: json, accountType: "monoclePost"){
            self = .instagram(instaMedia)
        }else if let tweet = Tweet(dictionary: json, postType: "tweet"){
            self = .tweet(tweet)
        }else{
            return nil
        }
    }
    
    static func array(json: [[String:Any]]) -> [MonoclePost]? {
        
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

enum MonoclePostsResult {
    case success([MonoclePost])
    case failure(Error)
}

class MonoclePostStore {
    
    var delegate: HomeVC?
    // Fetch Posts
    var monoclePosts = [MonoclePost]() {
        didSet {
//            delegate?.feedsCollectionView.reloadData()
        }
    }
    // MARK: Get Home timelines
    func getMonacleFriendTimelineFor(oTwitterID: String?, oInstagramID: String?) {
        let accessToken = UserDefaults.standard.object(forKey: "instagramToken") as? String
        
        if let twitterID = oTwitterID {
            TwitterClient.sharedInstance?.getUserTimeline(userID: twitterID, success: { (monoclePost) in
                self.monoclePosts = monoclePost
            }, failure: { (error) in
                print(error)
            })
        } else if let instaID = oInstagramID {
//            Instagram().fetchRecentMediaForUserMonocle(instaID, accessToken: accessToken!) { (monocleInstaPost) in
//                self.monoclePosts = monocleInstaPost
//            }
        }
    }
    
    func checkAccount(monocleUser: MonocleUser) {
        
//        switch monocleUser {
//            
//        case .instagramUser(let value):
//            monoclePosts.removeAll()
//            print(value)
//        case .twitterUser(let value):
//            FirebaseService.instance.selectedUser = monocleUser
//            if FirebaseService.instance.checkAccounts(monocleUser: monocleUser) == "instagram" {
//                print("Has InstagramAccount")
//                monoclePosts.removeAll()
//                // GetInstaFeed
//                getMonacleFriendTimelineFor(oTwitterID: value.uid, oInstagramID: value.uid)
//            } else {
//                print("no instagram account")
//                monoclePosts.removeAll()
//                // Get tweets
//                getMonacleFriendTimelineFor(oTwitterID: value.uid, oInstagramID: nil)
//            }
//        }
    }
    
}






