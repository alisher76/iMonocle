//
//  Group.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/22/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation


class Group {
    private var _groupTitle: String
    private var _groupDesc: String
    private var _groupID: String
    private var _groupMemberCount: Int
    private var _groupMembers: [String]
    
    var groupTitle: String {
        return _groupTitle
    }
    var groupDesc: String {
        return _groupDesc
    }
    var groupMemberCount: Int {
        return _groupMemberCount
    }
    var groupID: String {
        return _groupID
    }
    var groupMembers: [String] {
        return _groupMembers
    }
    
    init(groupTitle: String, groupDesc: String, groupID: String, groupMemberCount: Int, groupMembers: [String]) {
        self._groupTitle = groupTitle
        self._groupDesc = groupDesc
        self._groupID = groupID
        self._groupMemberCount = groupMemberCount
        self._groupMembers = groupMembers
    }
}
