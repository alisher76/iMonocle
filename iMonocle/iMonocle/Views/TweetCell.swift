//
//  TweetCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/15/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class TweetCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var mediaImageViewHeight: NSLayoutConstraint!
    
    var tweet: Tweet? {
        didSet {
            setUp()
        }
    }
    
    func setUp() {
        profileImageView.downloadFrom(url: (tweet?.authorProfilePic)!)
        nameLabel.text = tweet?.author
        userNameLabel.text = tweet?.screenName
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mediaImageViewHeight.isActive = false
        self.mediaImageView.sizeToFit()
        self.mediaImageView.layer.cornerRadius = 5
        self.mediaImageView.clipsToBounds = true
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 0.65
        self.layer.shadowRadius = 7.0
        self.layer.masksToBounds = false
    }
}
