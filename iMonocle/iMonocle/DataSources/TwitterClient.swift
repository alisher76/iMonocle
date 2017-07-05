//
//  TwitterClient.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/3/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    //OAuth = Fetch Request Token + redirect to auth + fetch access token + callback url
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "YJHFbPWaKlzWFW8MG1PFVBshS", consumerSecret: "HKco4y1pEpaupl2D3Vm4i1BG4CkhTCAVlJp5Q2cTsnsKuegZSL")
    
    //Getting request token to open up authorize link in safari
    var accessToken: String!
    var loginSuccess: (() ->())?
    var loginFailure: ((Error) ->())?
    weak var delegate: TwitterLoginDelegate?
    
    func login(success: @escaping () ->(), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"monocleVersionOne://success")!, scope: nil, success: { (requestToken) in
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
                self.delegate?.continueLogin()
                self.loginSuccess?()
            
        }) { (error) in
            self.loginFailure?(error!)
        }
    }
    
    
//    func currentAccount(success: @escaping (TwitterUser) -> (), failure: @escaping (Error) -> ()) {
//
//
//        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, responce) in
//            let userDict = responce as! NSDictionary
//            let user = TwitterUser(json: userDict, accountType: "twitter")
//            success(user!)
//        }) { (task, error) in
//            print(error.localizedDescription)
//            failure(error)
//        }
//
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
