//
//  FirebaseService.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/10/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Firebase
import Foundation

// Root to Firebase database
let DB_BASE = Database.database().reference()

class FirebaseService {
    
    static let instance = FirebaseService()
    // References
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    var currentUser: MonocleUser?
    
    
    var currentuserID: String?
    var selectedUser: MonocleUser?
    var selectedUserInstagramID: String?
    
    // MARK: login to Firebase
    func loginUserToFirebase(withEmail email: String, password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if Auth.auth().currentUser?.email == email {
                print("Successfully logged in")
                SavedStatus.instance.isLoggedIn = true
                SavedStatus.instance.userID = (user?.uid)!
                SavedStatus.instance.currentUserEmail = (user?.email)!
                self.currentuserID = Auth.auth().currentUser?.uid
                loginComplete(true, nil)
            } else {
                loginComplete(false, error)
                }
            }
        }
    
    
    // MARK: Logout user
    
    func logout() {
        
        do{
            try Auth.auth().signOut()
        }catch{
            print("Error while signing out!")
        }
    }
    
    // MARK: register user
    func registerUserToFirebase(withEmail email: String, password: String, name: String, accountType: String, token: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("\(error.debugDescription)")
                userCreationComplete(false, nil)
            } else {
                let userData = ["provider": user?.providerID, "email": user?.email, "name": name, "createdAccountWith": accountType, "token": token]
                FirebaseService.instance.createDBUser(uid: (user?.uid)!, userData: userData)
                SavedStatus.instance.isLoggedIn = true
                SavedStatus.instance.userID = (user?.uid)!
                userCreationComplete(true, error)
            }
        }
    }
    
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func updateAccount(uid: String, account: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).child("accounts").child(account).updateChildValues(userData)
    }
    
    func updateFriendsCollection(monocleUser: MonocleUser) {
        
        var back: [String:Any] = [:]
        
        switch monocleUser {
            
        case .instagramUser(let instagramUser):
            let data: [String:Any] = [
                "full_name": instagramUser.fullName,
                "username": instagramUser.userName,
                "id": instagramUser.uid,
                "profile_picture": instagramUser.image,
                "accountType": instagramUser.accountType
            ]
            back = data
        REF_USERS.child(SavedStatus.instance.userID).child("friends").child(instagramUser.fullName).child("instagram").setValue(back)
            
        case .twitterUser(let twitterUser):
            let data: [String: Any] = [ "name":"\(twitterUser.name)",
                "id_str":"\(twitterUser.uid)",
                "screen_name":"\(twitterUser.screenName)",
                "followers_count":"\(twitterUser.followerCount)",
                "friends_count":"\(twitterUser.followingCount)",
                "description":"\(twitterUser.description)",
                "location":"\(twitterUser.location)",
                "profile_image_url_https":"\(twitterUser.image)"]
            back = data
      REF_USERS.child(SavedStatus.instance.userID).child("friends").child(twitterUser.name).child("twitter").setValue(back)
        }
        
        
    }
    
    // MARK: Update Selected Friend Account
    func updateSelectedFriendAccount(selectedUser: MonocleUser ,monocleUser: MonocleUser) {
        
        var back: [String:Any] = [:]
        
        switch monocleUser {
        case .instagramUser(let instagramUser):
//            currentUserName = instagramUser.userName
            let data: [String:Any] = [
                "full_name": instagramUser.fullName,
                "username": instagramUser.userName,
                "id": instagramUser.uid,
                "profile_picture": instagramUser.image,
                "createdAccountWith": instagramUser.accountType
            ]
            back = data
            
            // Switch the selected Monocle Friend
            switch selectedUser {
            case .instagramUser(let instagramUser):
                REF_USERS.child(SavedStatus.instance.userID).child("friends").child(instagramUser.fullName).child("instagram").setValue(back)
            case .twitterUser(let twitterUser):
                REF_USERS.child(SavedStatus.instance.userID).child("friends").child(twitterUser.name).child("instagram").setValue(back)
            }
            
        case .twitterUser(let twitterUser):
//            currentUserName = twitterUser.screenName
            let data: [String: Any] = [ "name":"\(twitterUser.name)",
                "id_str":"\(twitterUser.uid)",
                "screen_name":"\(twitterUser.screenName)",
                "followers_count":"\(twitterUser.followerCount)",
                "friends_count":"\(twitterUser.followingCount)",
                "description":"\(twitterUser.description)",
                "location":"\(twitterUser.location)",
                "profile_image_url_https":"\(twitterUser.image)"]
            back = data
            
        // Switch the selected Monocle Friend
        switch selectedUser {
        case .twitterUser(let twitterUser):
            REF_USERS.child(SavedStatus.instance.userID).child("friends").child(twitterUser.name).child("twitter").setValue(back)
        case .instagramUser(let instagramUser):
            REF_USERS.child(SavedStatus.instance.userID).child("friends").child(instagramUser.fullName).child("twitter").setValue(back)
        }
       }
    }
    
   func checkInitialSignedInSMediaType(sMediaType: @escaping (String) -> ()) {
        guard let currentUser = Auth.auth().currentUser else {return}
        REF_USERS.child(SavedStatus.instance.userID).observe(.value) { (snapshot) in
            if snapshot.hasChild("twitter") {
                sMediaType("twitter")
            } else {
                sMediaType("instagram")
            }
        }
    }
    
    func getCurrentUserInfo(userInfo: @escaping (MonocleUser) -> ()) {
        var monocleUser: MonocleUser?
        REF_USERS.child(SavedStatus.instance.userID).child("accounts").observeSingleEvent(of: .value) { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                guard let mUser = user.value as? [String : Any] else { return }
                monocleUser = MonocleUser(json: mUser)
            }
            if self.isCurrentUser(user: monocleUser!) {
                self.checkCurrentUserAccount(user: monocleUser!, account: { (account) in
                    print(account)
                })
            }
            userInfo(monocleUser!)
        }
        
    }
    // MARK: Current User selected?
    func isCurrentUser(user: MonocleUser) -> Bool {
        switch user {
        case .instagramUser(let iUser):
            if iUser.userName == SavedStatus.instance.currentUserEmail {
                return true
            }
        case .twitterUser(let tUser):
            if "\(tUser.screenName)@monocle.com" == SavedStatus.instance.currentUserEmail {
                return true
            }
        }
        return false
    }
    
    func hasInstagramAccount(monocleUser: MonocleUser, endPoint: String, hasInstagram: @escaping (Bool) -> ()) {
        
        var name = ""
        switch monocleUser {
        case .instagramUser(let value):
            name = value.fullName
            REF_USERS.child(SavedStatus.instance.userID).child(endPoint).child(name).observe(.value, with: { (snapShot) in
                if snapShot.hasChild("instagram") {
                    SavedStatus.instance.instagramAuthToken = snapShot.childSnapshot(forPath: "instagram").childSnapshot(forPath: "token").value as! String
                    hasInstagram(true)
                } else {
                    hasInstagram(false)
                }
            })
        case .twitterUser(let value):
            name = value.name
            REF_USERS.child(SavedStatus.instance.userID).child(endPoint).child(name).observe(.value, with: { (snapShot) in
                if snapShot.hasChild("instagram") {
                    self.selectedUserInstagramID = snapShot.childSnapshot(forPath: "instagram").childSnapshot(forPath: "id").value as? String
                    SavedStatus.instance.selectedUserInstagramID = self.selectedUserInstagramID!
                    hasInstagram(true)
                } else {
                    hasInstagram(false)
                }
            })
        }
        
    }
    
    
    func checkCurrentUserAccount(user: MonocleUser, account: @escaping (String) -> ()) {
        switch user {
        case .instagramUser:
              account("instagram")
        case .twitterUser:
            REF_USERS.child(SavedStatus.instance.userID).child("accounts").observe(.value, with: { (snapshot) in
                if snapshot.hasChild("instagram") && snapshot.hasChild("twitter") {
                    account("both")
                    self.selectedUserInstagramID = snapshot.childSnapshot(forPath: "instagram").childSnapshot(forPath: "id").value as? String
                    SavedStatus.instance.instagramAuthToken = snapshot.childSnapshot(forPath: "instagram").childSnapshot(forPath: "token").value as! String
                    SavedStatus.instance.currentUserInstagramID = snapshot.childSnapshot(forPath: "instagram").childSnapshot(forPath: "id").value as! String
                } else if snapshot.hasChild("instagram") {
                    self.selectedUserInstagramID = snapshot.childSnapshot(forPath: "instagram").childSnapshot(forPath: "id").value as? String
                    SavedStatus.instance.currentUserInstagramID = self.selectedUserInstagramID!
                    SavedStatus.instance.instagramAuthToken = snapshot.childSnapshot(forPath: "instagram").childSnapshot(forPath: "token").value as! String
                    account("instagram")
                } else if snapshot.hasChild("twitter") {
                    account("twitter")
                }
            })
        }
    }
    
    func checkAccounts(monocleUser: MonocleUser, hasAccount: @escaping (String) -> ()) {
        
        switch monocleUser {
        case .instagramUser(let value):
            REF_USERS.child(SavedStatus.instance.userID).child("friends").child(value.fullName).observe(.value, with: { (snapShot) in
                if snapShot.hasChild("instagram") {
                    hasAccount("instagram")
                } else {
                    hasAccount("twitter")
                }
            })
        case .twitterUser(let value):
            REF_USERS.child(SavedStatus.instance.userID).child("friends").child(value.name).observe(.value, with: { (snapShot) in
                if snapShot.hasChild("twitter") && snapShot.hasChild("instagram") {
                    hasAccount("both")
                } else if snapShot.hasChild("twitter"){
                    hasAccount("twitter")
                } else if snapShot.hasChild("instagram") {
                    hasAccount("instagram")
                }
            })
        }
    }
    
    // MARK: Remove from data base
   func removeFromFriendsList(monocleUser: MonocleUser) {
        switch monocleUser {
        case .instagramUser:
        REF_USERS.child(SavedStatus.instance.userID).child("friends").childByAutoId().child("instagram").removeValue()
                
        case .twitterUser(let twitterUser):
            twitterUser.firebaseRef?.removeValue()
         }
            
    }
    
    func currentUserAccount(success: @escaping ([MonocleUser]) -> ()) {
        var back: [MonocleUser] = []
        REF_USERS.child(SavedStatus.instance.userID).child("accounts").observe(.value) { (snapshot) in
            guard let accountsSnapshot = snapshot.value as? [String: [String:Any]] else { return }
            for (account, info) in accountsSnapshot {
                if account == "twitter" {
                    guard let tMonocleAccount = MonocleUser(json: info) else { return }
                    back.append(tMonocleAccount)
                } 
            }
            success(back)
        }
    }
    
    func currentListOfFriends(success: @escaping ([String: MonocleUser]) -> ()) {
        var back: [String: MonocleUser] = [:]
        
        REF_USERS.child(SavedStatus.instance.userID).child("friends").observe(.value) { (snapshot) in
            for _friend in snapshot.children {
              let friendSnap = _friend as! DataSnapshot
                if friendSnap.hasChild("twitter") {
                let friend = TwitterUser(snapshot: _friend as! DataSnapshot, account: "twitter")
                back[friend.name] = MonocleUser(snapshot: _friend as! DataSnapshot)
                }
            }
            success(back)
        }
    }
    
     func currentListOfInstagramFriends(initialSMedia: String, selectedUser: MonocleUser, success: @escaping ([String: MonocleUser]) -> ()) {
        var back: [String: MonocleUser] = [:]
        
        switch selectedUser {
        case .instagramUser(let instaUser):
            REF_USERS.child(SavedStatus.instance.userID).child(initialSMedia).child(instaUser.userName).observe(.value) { (snapshot) in
                guard let snapValue = snapshot.value as? [String: [String:Any]] else {return}
                
                for (_, _value) in snapValue {
                    if let value = _value["twitter"] as? [String:Any] {
                        
                        if let twitterUser = TwitterUser(dictionary: value, accountType: "Twitter") {
                            
                            back[twitterUser.screenName] = MonocleUser.twitterUser(twitterUser)
                        }
                    }
                }
            }
            success(back)
        case .twitterUser(let twitterUser):
            REF_USERS.child(SavedStatus.instance.userID).child(initialSMedia).child(twitterUser.screenName).observe(.value) { (snapshot) in
                guard let snapValue = snapshot.value as? [String: [String:Any]] else {return}
                
                for (_, _) in snapValue {
                    if let value = snapValue["instagram"] {
                        
                        if let instagramUser = InstagramUser(json: value, accountType: "instagram") {
                            back[instagramUser.userName] = MonocleUser.instagramUser(instagramUser)
                            success(back)
                        }
                    }
                }
            }
        }
    }
    
}
