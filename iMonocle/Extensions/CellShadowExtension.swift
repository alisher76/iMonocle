//
//  CellShadowExtension.swift
//  iMonoPrototype
//
//  Created by Alisher Abdukarimov on 8/19/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class CellShadowExtension: UICollectionViewCell {
    
    func addShadow() {
        self.layer.cornerRadius = 25
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
    }
}
