//
//  UICollectionVIewCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 10/2/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    func animateFriendsCell() {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 500, 0, 0)
        self.layer.transform = rotationTransform
        self.contentView.alpha = 0.5
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.layer.transform = CATransform3DIdentity
            self.contentView.alpha = 1
        }, completion: { (success) in
            print(success)
        })
    }
    
    func animateInstaCell() {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 500, 0, 0)
        self.layer.cornerRadius = 0.5
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.transform = rotationTransform
        self.contentView.alpha = 0.5
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.layer.transform = CATransform3DIdentity
            self.layer.cornerRadius = 5.0
            self.layer.shadowColor = UIColor.darkGray.cgColor
            self.layer.shadowOffset = CGSize(width:0,height: 2.0)
            self.layer.shadowRadius = 2.0
            self.layer.shadowOpacity = 1.0
            self.layer.masksToBounds = false
            self.contentView.alpha = 1
            self.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        }, completion: { (success) in
            print(success)
        })
    }
    
    func configureCell() {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 0.4
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = UIColor.clear
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 5.0)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}

