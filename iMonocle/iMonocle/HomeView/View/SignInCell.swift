//
//  SignInCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/22/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class SignInCell: UICollectionViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    var delegate: HomeViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.authInstagramVC()
    }
}
