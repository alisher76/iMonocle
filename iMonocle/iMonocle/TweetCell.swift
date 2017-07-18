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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mediaImageViewHeight.isActive = false
        self.mediaImageView.sizeToFit()
        self.mediaImageView.layer.cornerRadius = 5
        self.mediaImageView.clipsToBounds = true
        
        self.layer.shadowColor = UIColor(red: 0.7176470757, green: 0.7176470757, blue: 0.7176470757, alpha: 1.0000000000).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 2.5
        self.layer.masksToBounds = false
    }
}
