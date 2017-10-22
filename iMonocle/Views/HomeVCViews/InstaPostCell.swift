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

