//
//  CircleImage.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 8/29/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}


