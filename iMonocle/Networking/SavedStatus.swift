//
//  SavedStatus.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 8/31/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation
import Firebase

class SavedStatus {
    
    static let instance = SavedStatus()
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var isLoggedInToInstagram: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_TO_INSTAGRAM_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_TO_INSTAGRAM_KEY)
        }
    }
    
    var isLoggedInToTwitter: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_TO_TWITTER_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_TO_TWITTER_KEY)
        }
    }
    
    var instagramAuthToken: String {
        get {
            return defaults.value(forKey: INSTAGRAM_TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: INSTAGRAM_TOKEN_KEY)
        }
    }
    
    var twitterAuthToken: String {
        get {
            return defaults.value(forKey: TWITTER_TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TWITTER_TOKEN_KEY)
        }
    }
    
    var currentUserEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    var userID: String {
        get {
            if let back = defaults.value(forKey: USER_ID) as? String {
                return back
            } else {
                return "123456"
            }
        }
        set {
            defaults.set(newValue, forKey: USER_ID)
        }
    }
    
    var currentUserInstagramID: String {
        get {
            return defaults.value(forKey: USER_INSTAGRAM_ID) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_INSTAGRAM_ID)
        }
    }
    
    var selectedUserInstagramID: String {
        get {
            return defaults.value(forKey: SELECTED_USER_INSTAGRAM_ID) as! String
        }
        set {
            defaults.set(newValue, forKey: SELECTED_USER_INSTAGRAM_ID)
        }
    }
    
    func cleanUpSavedStatus() {
        
        currentUserInstagramID = ""
        userID = ""
        twitterAuthToken = ""
        instagramAuthToken = ""
        isLoggedInToTwitter = false
        isLoggedInToInstagram = false
        isLoggedIn = false
    }
}
