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
    
    func createMonoShareDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        if groupKey != nil {
            // send to groupd ref
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["message": message, "fromID": uid])
            sendComplete(true)
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "fromID": uid])
            sendComplete(true)
        }
    }
    
    func getAllMessages(handler: @escaping (_ messages: [String:Message]) -> ()) {
        
        var messageDictionary = [String:Message]()
        REF_MESSAGES.observe(.childAdded) { (feedMessageSnap) in
            guard let dictioanry = feedMessageSnap.value as? [String : Any] else { return }
            let message = Message(dictionary: dictioanry)
            
            let toID = message.toId
            messageDictionary[toID] = message
            handler(messageDictionary)
            }
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
    
    func sendMessage(message: String, uid: String, sendComplete: @escaping (_ status: Bool) -> ()) {
        
        let fromID = SavedStatus.instance.userID
        
        let date: Date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let values = ["message": message, "toID": uid, "fromID": fromID, "time": "\(hour):\(minutes)"]
        
        REF_MESSAGES.childByAutoId().updateChildValues(values)
    }
    
    func getAllMessagesFor(desiredGroup: Group, handler: @escaping(_ messagesArray: [Message]) -> ()) {
        var messages = [Message]()
//        REF_GROUPS.child(desiredGroup.groupID).child("messages").observeSingleEvent(of: .value) { (groupMessagesSnapshot) in
//            guard let groupMessagesSnapshot = groupMessagesSnapshot.children.allObjects as? [DataSnapshot] else { return }
//            for groupMessage in groupMessagesSnapshot {
//                let content = groupMessage.childSnapshot(forPath: "content").value as! String
//                let senderID = groupMessage.childSnapshot(forPath: "senderId").value as! String
//                let gMessage = Message(content: content, senderId: senderID, toId: <#T##String#>, time: <#T##String#>)
//                messages.append(gMessage)
//            }
//            handler(messages)
//        }
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
    
    // Get group
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        
        var groupsArray = [Group]()
        
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnap) in
            guard let groupSnapshot = groupSnap.children.allObjects as? [DataSnapshot] else { return }
            for group in groupSnapshot {
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                let title = group.childSnapshot(forPath: "title").value as! String
                let desc = group.childSnapshot(forPath: "description").value as! String
                
                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
                    let group = Group(groupTitle: title, groupDesc: desc, groupID: group.key, groupMemberCount: memberArray.count, groupMembers: memberArray)
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
    }
    
    // MARK: Create a Channel
    
    func createChannel(withTitle title: String, withDiscription description: String, channelImage image: String, handler: @escaping (_ groupCreated: Bool) -> ()) {
        REF_CHANNELS.childByAutoId().updateChildValues(["title": title, "description": description, "image": image])
        handler(true)
    }
    
    // Get group
    
    func getAllChannels(handler: @escaping (_ groupsArray: [Channel]) -> ()) {
        
        var channelsArray = [Channel]()
        
        REF_CHANNELS.observeSingleEvent(of: .value) { (channelSnap) in
            guard let channelSnapshot = channelSnap.children.allObjects as? [DataSnapshot] else { return }
            for _channel in channelSnapshot {
                let title = _channel.childSnapshot(forPath: "title").value as! String
                let desc = _channel.childSnapshot(forPath: "description").value as! String
                let image = _channel.childSnapshot(forPath: "image").value as! String
                let channel = Channel(channelTitle: title, channelDesc: desc, channelImage: image)
                    channelsArray.append(channel)
            }
            handler(channelsArray)
        }
    }
    
    func getAllUsers(result: @escaping (_ result: [MonocleShareUser]) -> ()) {
        var usersArray = [MonocleShareUser]()
        REF_USERS.observeSingleEvent(of: .value) { (friendsSnap) in
            guard let friends = friendsSnap.children.allObjects as? [DataSnapshot] else { return }
            for _friend in friends {
                guard let name = _friend.childSnapshot(forPath: "name").value as? String else { return }
                guard let email = _friend.childSnapshot(forPath: "email").value as? String else { return }
                let userKey = _friend.key
                let user = MonocleShareUser(name: name, id: userKey, email: email)
                usersArray.append(user)
            }
            result(usersArray)
        }
    }
    
    
    func sendMessage(withMessage message: String, forName name: String, sendComplete: @escaping (_ status: Bool) -> ()) {
        REF_USERS.child("messages").child(name).childByAutoId().updateChildValues(["message": message, "fromID": FirebaseService.instance.currentuserID!])
        sendComplete(true)
    }
    
    func getAllMessages(name: String, handler: @escaping (_ groupsArray: [Message]) -> ()) {
        
        var messagesArray = [Message]()
        
        REF_USERS.child("messages").child(name).observeSingleEvent(of: .value) { (messages) in
            
            guard let messagesSnapshot = messages.children.allObjects as? [DataSnapshot] else { return }
            for _message in messagesSnapshot {
                let content = _message.childSnapshot(forPath: "message").value as! String
                let senderId = _message.childSnapshot(forPath: "fromID").value as! String
                let toId = _message.childSnapshot(forPath: "toID").value as! String
                let time = _message.childSnapshot(forPath: "time").value as! String
                let message = Message(content: content, senderId: senderId, toId: toId, time: time)
                messagesArray.append(message)
            }
            handler(messagesArray)
        }
    }
}
