//
//  Message.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/22/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation

class Message {
    
    private var _content: String
    private var _senderId: String
    private var _toId: String
    private var _time: String
    
    var content: String {
        return _content
    }
    
    var senderId: String {
        return _senderId
    }
    
    var toId: String {
        return _toId
    }
    
    var time: String {
        return _time
    }
    
    init(content: String, senderId: String, toId: String, time: String) {
        self._senderId = senderId
        self._content = content
        self._toId = toId
        self._time = time
    }
    
    init(dictionary: [String:Any]) {
        self._senderId = dictionary["fromID"] as! String
        self._toId = dictionary["toID"] as! String
        self._time = dictionary["time"] as! String
        self._content = dictionary["message"] as! String
    }
}
