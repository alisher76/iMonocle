//
//  InstaPostCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 8/29/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class InstaPostCell: UICollectionViewCell {
    
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var profileImage: CircleImage!
    @IBOutlet weak var postMedia: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 25
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    func setupCell(post: MonoclePost) {
        switch post {
        case .instagram(let instagramPost):
            postDescription.text = instagramPost.caption
            profileImage.downloadedFrom(link: instagramPost.avatarURL)
            postMedia.downloadedFrom(link: instagramPost.takenPhoto)
        default:
            break
        }
    }
}

