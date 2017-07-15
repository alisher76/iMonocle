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
    }
}
