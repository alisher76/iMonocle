//
//  FeedsCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/14/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class FeedsCell: UICollectionViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var imageViewConstantHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.postImageView.isActive = false
        self.postImageView.sizeToFit()
        self.postImageView.layer.cornerRadius = 5
        self.postImageView.clipsToBounds = true
        self.profileImage.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowColor = UIColor(red: 0.7176470757, green: 0.7176470757, blue: 0.7176470757, alpha: 1.0000000000).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.profileImage.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 1.0
        self.profileImage.layer.shadowOpacity = 0.35
        self.layer.shadowRadius = 2.5
        self.profileImage.layer.shadowRadius = 2.5
        self.layer.masksToBounds = false
        self.profileImage.layer.masksToBounds = false
        self.profileImage.clipsToBounds = false
    }
}
