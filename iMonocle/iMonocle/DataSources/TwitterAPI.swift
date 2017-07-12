//
//  TwitterAPI.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/7/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    //OAuth = Fetch Request Token + redirect to auth + fetch access token + callback url
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "C6ci8pKlOBM1VucP23xrZhmJv", consumerSecret: "9oxATwn6U1XEAM7zK85Hh0CN4KfQ1mXqovUSgKk767esLZKO4w")
    
    //Getting request token to open up authorize link in safari
    var accessToken: String!
    var loginSuccess: (() ->())?
    var loginFailure: ((Error) ->())?
    
    
    func login(success: @escaping () ->(), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"iMonocle://success")!, scope: nil, success: { (requestToken) in
            print("Got token")
            let url = URL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=" + (requestToken?.token)!)!
            UIApplication.shared.open(url)
            
        }) { (error) in
            print("Error")
            self.loginFailure?(error!)
        }
    }
    
    
    //Get access token and save user
    func handleOpenURL(url: URL) {
        //get access token
        let requestToken = BDBOAuth1Credential(queryString: url.query)!
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken) in
            self.loginSuccess?()
            self.loginSuccess?()
            
        }) { (error) in
            self.loginFailure?(error!)
        }
    }
    
    
    func currentAccount(success: @escaping (TwitterUser) -> (), failure: @escaping (Error) -> ()) {
        
        get("/1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, responce) in
            let userDict = responce as! [String:Any]
            let user = TwitterUser(dictionary: userDict, accountType: "twitter")
            success(user!)
        }) { (task, error) in
            print(error.localizedDescription)
            failure(error)
        }
    }
    
    //Get FriendsList
    
    
    func getListOfFollowedFriends(success: @escaping ([MonocleUser]) -> (), failure: @escaping (Error) -> ()) {
        
        let params = ["count": 10]
        var monocleUser = [MonocleUser]()
        
        get("1.1/friends/list.json", parameters: params, progress: nil, success: { (task, responce) in
            if let usersDictionary = responce as? [String:Any] {
                let anime = usersDictionary["users"] as? [[String:Any]]
                guard let users = TwitterUser.array(json: anime!) else {return}
                for user in users {
                    let _monocleUser = MonocleUser.twitterUser(user)
                    monocleUser.append(_monocleUser)
                }
                success(monocleUser)
            }
        }) { (task, error) in
            print(error.localizedDescription)
            
        }
    }
    
}
