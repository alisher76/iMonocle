//
//  MonoShareDataService.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/22/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation
import Firebase

class MonoShareDataService {
    
    static let instance = MonoShareDataService()
    
    // References
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_CHANNELS = DB_BASE.child("channels")
    private var _REF_FEED = DB_BASE.child("feed")
    private var _REF_MESSAGES = DB_BASE.child("messages")
    private var _REF_USER_MESSAGES = DB_BASE.child("user-messages")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_MESSAGES: DatabaseReference {
        return _REF_MESSAGES
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_CHANNELS: DatabaseReference {
        return _REF_CHANNELS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    var REF_USER_MESSAGES: DatabaseReference {
        return _REF_USER_MESSAGES
    }
    
    var messages = [Message]()
    var messagesDictionary = [String:Message]()
    
    func getAllMessages(handler: @escaping (_ messagesDictionary: [String: Message]) -> ()) {
        
        var messageDictionary = [String: Message]()
        var messageArray = [Message]()
        REF_MESSAGES.observe(.value) { (messageSnap) in
            guard let messageSnapshot = messageSnap.children.allObjects as? [DataSnapshot] else { return }
            for i in messageSnapshot {
                if i.childSnapshot(forPath: "toID").hasChild(SavedStatus.instance.userID) {
                    let message = Message(content: i.value(forKey: "content") as! String, senderId: i.value(forKey: "fromID") as! String, toId: i.value(forKey: "toID") as! String, time: i.value(forKey: "time") as! String)
                    messageArray.append(message)
                    messageDictionary[message.toId] = message
                }
            }
            handler(messageDictionary)
            
        }
    }
    
    func getAllMessagess(gotMessages: @escaping (_ messages: [Message]) -> ()) {
        var messageDictionary = [String: Message]()
        var messagesArray = [Message]()
        REF_MESSAGES.observeSingleEvent(of: .value, with: { (dataSnapshot) in
            guard let snapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for i in snapshot {
                guard let dictionary = i.value as? [String:Any] else { return }
                let message = Message(content: dictionary["message"] as! String, senderId: dictionary["fromID"] as! String, toId: dictionary["toID"] as! String, time: dictionary["time"] as! String)
                messagesArray.append(message)
                messageDictionary[message.toId] = message
            }
            messagesArray = Array(messageDictionary.values)
            gotMessages(messagesArray)
        }, withCancel: nil)
    }
    
    // MARK: Get User Name
    
    func getUserName(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (_userSnapshot) in
            guard let userSnapshot = _userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    // MARK: Get Email
    
    func getEmailForSearchQuery(query: String, handler: @escaping (_ result: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if email.contains(query) && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    // Mark: Send Message
    func send(message: String, with uid: String, sendComplete: @escaping (_ status: Bool) -> ()) {
        
        let fromID = SavedStatus.instance.userID
        let childRef = REF_MESSAGES.childByAutoId()
        let timestamp = Int(Date().timeIntervalSince1970)
        
        let values: [String : Any] = ["message": message, "toID": uid, "fromID": fromID, "time": timestamp]
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error.debugDescription)
            }
            
            let userMessageRef = self.REF_USER_MESSAGES.child(fromID)
            let messageID = childRef.key
            userMessageRef.updateChildValues([messageID:1])
        }
        
        childRef.updateChildValues(values)
        sendComplete(true)
    }
    
    // Mark: Observe messages
    func observeUserMessage() {
        let ref = _REF_USER_MESSAGES.child(SavedStatus.instance.userID)
        ref.observeSingleEvent(of: .childAdded, with: { (messagesSnapshot) in
            let messageId = messagesSnapshot.key
            let messageRefenrence = self.REF_MESSAGES.child(messageId)
            messageRefenrence.observeSingleEvent(of: .value, with: { (messageSnapshot) in
                print(messagesSnapshot)
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    
    // MARK: Get ids
    
    func getIds(forUserNames usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        var idArray = [String]()
        
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let usersnp = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in usersnp {
                let email = user.childSnapshot(forPath: "email").value as! String
                if usernames.contains(email) {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    // MARK: Get emailsForGroup
    
    func getEmails(forGroup group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if group.groupMembers.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    // MARK: Create a group
    
    func createGroup(withTitle title: String, withDiscription description: String, forUserIds ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        handler(true)
    }
    
    // MARK: Create a Channel on Database
    
    func createChannel(withTitle title: String, withDiscription description: String, channelImage image: String, handler: @escaping (_ groupCreated: Bool) -> ()) {
        REF_CHANNELS.childByAutoId().updateChildValues(["title": title, "description": description, "image": image])
        handler(true)
        
    }
    
    
    // Mark: Get All Chanels from Databae
    func getAllChannels(handler: @escaping (_ groupsArray: [Channel]) -> ()) {
        
        var channelsArray = [Channel]()
        
        REF_CHANNELS.observeSingleEvent(of: .value) { (channelSnap) in
            guard let channelSnapshot = channelSnap.children.allObjects as? [DataSnapshot] else { return }
            for _channel in channelSnapshot {
                let title = _channel.childSnapshot(forPath: "title").value as! String
                let desc = _channel.childSnapshot(forPath: "description").value as! String
                let image = _channel.childSnapshot(forPath: "image").value as! String
                let channelID = _channel.key
                let channel = Channel(channelTitle: title, channelDesc: desc, channelImage: image, channelID: channelID)
                channelsArray.append(channel)
            }
            handler(channelsArray)
        }
    }
    
    // Mark: Get All Users from Databae
    func getAllUsers(result: @escaping (_ result: [MonocleShareUser]) -> ()) {
        var usersArray = [MonocleShareUser]()
        REF_USERS.observeSingleEvent(of: .value) { (friendsSnap) in
            guard let friends = friendsSnap.children.allObjects as? [DataSnapshot] else { return }
            for _friend in friends {
                guard let name = _friend.childSnapshot(forPath: "name").value as? String else { return }
                guard let email = _friend.childSnapshot(forPath: "email").value as? String else { return }
                var imageURL: String = ""
                if _friend.childSnapshot(forPath: "accounts").hasChild("instagram") {
                    let imageUrl = _friend.childSnapshot(forPath: "accounts").childSnapshot(forPath: "instagram").childSnapshot(forPath: "profile_picture").value as! String
                    imageURL = imageUrl
                } else {
                    guard let imageUrl = _friend.childSnapshot(forPath: "accounts").childSnapshot(forPath: "twitter").childSnapshot(forPath: "profile_image_url_https").value as? String else { return }
                    imageURL = imageUrl
                }
                let userKey = _friend.key
                let user = MonocleShareUser(name: name, id: userKey, email: email, image: imageURL)
                usersArray.append(user)
            }
            result(usersArray)
        }
    }
}
