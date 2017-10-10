//
//  MonocleShareUser.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/26/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation


class MonocleShareUser {
    
    private var _name: String
    private var _id: String
    private var _email: String
    
    var name: String {
        return _name
    }
    
    var email: String {
        return _email
    }
    
    var id: String {
        return _id
    }
    
    init(name: String, id: String, email: String) {
        self._id = id
        self._name = name
        self._email = email 
    }
}

