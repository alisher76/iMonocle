//
//  RoundedUIView.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/23/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedUIView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.tintColor = UIColor.white
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
}
