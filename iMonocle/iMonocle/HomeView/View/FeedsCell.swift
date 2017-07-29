//
//  FeedsCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/14/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class FeedsCell: UICollectionViewCell {
    
    @IBOutlet private weak var gradientView: GradientView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    var media: Media? {
        didSet {
            setUp()
        }
    }
    
    func setUp() {
        profileImage.downloadedFrom(link: (media?.avatarURL)!)
        nameLabel.text = media?.username
        postImageView.downloadedFrom(link: (media?.takenPhoto)!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.postImageView.isActive = false
        self.postImageView.sizeToFit()
        //self.postImageView.layer.cornerRadius = 5
        self.postImageView.clipsToBounds = true
        self.profileImage.layer.cornerRadius = 25
        self.profileImage.layer.borderColor = UIColor.lightGray.cgColor
        self.profileImage.layer.borderWidth = 1
        self.profileImage.clipsToBounds = true
        
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true;
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false;
    }
}
