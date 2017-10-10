//
//  FriendsListCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 8/29/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class FriendsListCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: CircleImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderColor = #colorLiteral(red: 0.173940599, green: 0.2419398427, blue: 0.3126519918, alpha: 0.222067637)
        self.layer.borderWidth = 2
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.clipsToBounds = true
    }
    
    func setupCell(friend: MonocleUser) {
        switch friend {
        case .twitterUser(let tUser):
            self.profileImage.downloadedFrom(link: tUser.image)
        case .instagramUser(let iUser):
            self.profileImage.downloadedFrom(link: iUser.image)
        }
    }
}

