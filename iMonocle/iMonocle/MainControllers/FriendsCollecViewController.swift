//
//  FriendsCollecViewController.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/13/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class FriendsCell: UICollectionViewCell {
    
    
    var imageView:UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor.blue
        iv.layer.cornerRadius = 25
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.borderWidth = 1
        iv.clipsToBounds = true
        return iv
    }()
    
    override var isHighlighted: Bool{
        didSet{
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.blue
        }
    }
    
    override var isSelected: Bool{
        didSet{
            imageView.tintColor = isSelected ? UIColor.blue : UIColor.darkGray
        }
    }
    
    override func awakeFromNib() {
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(50)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
