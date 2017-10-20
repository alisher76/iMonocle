//
//  MessagesCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/22/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import Firebase

class MessagesCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImageView: CircleImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastMessagePreviewLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setupCell(message: Message) {
            FirebaseService.instance.REF_USERS.child(message.toId).observe(.value, with: { (userInfoSnap) in
                guard let name = userInfoSnap.childSnapshot(forPath: "name").value as? String else { return }
                self.userNameLabel.text = name
                self.lastMessagePreviewLabel.text = message.content
                self.timeLabel.text = message.time
            })
    }

}
