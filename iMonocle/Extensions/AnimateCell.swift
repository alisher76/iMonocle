//
//  AnimateCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 10/2/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func animateTweetCell() {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 100, 0)
//        self.layer.cornerRadius = 0.5
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.layer.transform = rotationTransform
        self.contentView.alpha = 0.5
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.layer.transform = CATransform3DIdentity
//            self.layer.cornerRadius = 5
            self.layer.shadowColor = UIColor.darkGray.cgColor
            self.layer.shadowOffset = CGSize(width:0,height: 2.0)
            self.layer.shadowRadius = 2.0
            self.layer.shadowOpacity = 1.0
            self.layer.masksToBounds = false
            self.clipsToBounds = true
            self.contentView.alpha = 1
            self.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        }, completion: { (success) in
            //print(success)
        })
    }
    
    func animateInstaCell() {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 500, 0, 0)
        self.layer.transform = rotationTransform
        self.contentView.alpha = 0.5
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.layer.transform = CATransform3DIdentity
            self.layer.masksToBounds = false
            self.contentView.alpha = 1
        }, completion: { (success) in
            print(success)
        })
    }
}

extension UICollectionViewCell {
    func animateSegmentCell() {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -100, 0)
        self.layer.transform = rotationTransform
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.layer.transform = CATransform3DIdentity
        }, completion: { (success) in
            //print(success)
        })
    }
    
}
