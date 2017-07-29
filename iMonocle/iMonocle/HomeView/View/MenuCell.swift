//
//  MenuCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/13/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    var imageView:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.lightGray
        return iv
    }()
    
    
    
    override var isSelected: Bool{
        didSet{
            if isSelected {
                imageView.tintColor = UIColor.darkGray
                
            } else {
                imageView.tintColor = UIColor.lightGray
            }
        }
    }
    
    override func awakeFromNib() {
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(28)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(28)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.65
        self.layer.shadowRadius = 3.0
        self.layer.masksToBounds = false
    }
}


