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
    }
}
