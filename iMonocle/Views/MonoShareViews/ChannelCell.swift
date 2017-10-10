//
//  ChannelCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/22/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {
    
    @IBOutlet weak var channelImageView: CircleImage!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var channelDescriptionLabel: UILabel!
    @IBOutlet weak var numberOfMembersLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func setupCell(channel: Channel) {
        channelImageView.image = UIImage(named: channel.channelImage)
        channelNameLabel.text = channel.channelTitle
        channelDescriptionLabel.text = channel.channelDesc
    }

}
