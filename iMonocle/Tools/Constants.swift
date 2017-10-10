//
//  Constants.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/29/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

enum StoryboardIdentifier: String {
    case menuReuseIdentifier = "menuCell"
    case feedReuseIdentifier = "feedCell"
    case tweetReuseIdentifier = "tweetCell"
    case friendsReuseIdentifier = "friendsCell"
    case signInReuseIdentifier = "signInCell"
    case dateReuseIdentifier = "dateCell"
    case unwindToChannel = "unwindToChannel"
    case loginInstagramVC = "loginInstagramVC"
    case avatarPicker = "pickAvatar"
    case selectFriendVC = "selectMonocleUserVC"
    case chatVC = "ChatVC"
    case accountInfoVC = "accountInfoVC"
}

// URL Constants

let BASE_URL = "https://imonoclechat.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_CHANNEL = "\(BASE_URL)channel/"
let URL_GET_MESSAGES = "\(BASE_URL)message/byChannel/"

// user defaults
let INSTAGRAM_TOKEN_KEY = "instagramToken"
let LOGGED_IN_TO_INSTAGRAM_KEY = "loggedInToInstagram"
let TWITTER_TOKEN_KEY = "twitterToken"
let LOGGED_IN_TO_TWITTER_KEY = "loggedInToTwitter"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"
let USER_ID = "userID"
let USER_INSTAGRAM_ID = "userInstagramID"
let SELECTED_USER_INSTAGRAM_ID = "selectedUserInstagramID"

// Notification Constants

let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_CHANNELS_LOADED = Notification.Name("channelsLoaded")
let NOTIF_CHANNELS_SELECTED = Notification.Name("channelSelected")


