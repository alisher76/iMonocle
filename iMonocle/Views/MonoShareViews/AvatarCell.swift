//
//  AvatarCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 10/16/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
 
    @IBOutlet var avatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func configureCell(index: Int, type: AvatarType) {
        if type == AvatarType.dark {
            avatarImageView.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        } else {
            avatarImageView.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        }
    }
    
    func setup() {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
}
