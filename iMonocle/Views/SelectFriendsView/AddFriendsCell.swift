//
//  AddFriendsCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 8/29/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class AddFriendCell: UITableViewCell {
    
    @IBOutlet weak var profileIMage: UIImageView!
    @IBOutlet weak var sMediaLogo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var currentSelectedFriends = [String:MonocleUser]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(friend: MonocleUser) {
        
        switch friend {
        case .instagramUser(let iUser):
            self.profileIMage.downloadedFrom(link: iUser.image)
        case .twitterUser(let tUser):
            if currentSelectedFriends[tUser.name] != nil {
                self.accessoryType = .checkmark
            }
            self.profileIMage.downloadedFrom(link: tUser.image)
            self.nameLabel.text = tUser.name
            self.userNameLabel.text = tUser.screenName
        }
    }
    
}
