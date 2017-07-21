//
//  DetailVCCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/19/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var numberOfComments: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
