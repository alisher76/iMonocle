//
//  FirebaseDatabase.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/8/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation


struct MonocleFirebase {
    let name: String
    let friends: [String:[String:String]]
    
    init(name: String, friends: [String:[String:String]]) {
        self.name = name
        self.friends = friends
    }
}


