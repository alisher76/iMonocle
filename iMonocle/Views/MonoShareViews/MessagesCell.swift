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
                if userInfoSnap.childSnapshot(forPath: "accounts").hasChild("instagram") {
                    let imageUrl = userInfoSnap.childSnapshot(forPath: "accounts").childSnapshot(forPath: "instagram").childSnapshot(forPath: "profile_picture").value as! String
                    self.userProfileImageView.downloadedFrom(link: imageUrl)
                } else {
                    let imageUrl = userInfoSnap.childSnapshot(forPath: "accounts").childSnapshot(forPath: "twitter").childSnapshot(forPath: "profile_image_url_https").value as! String
                    self.userProfileImageView.downloadedFrom(link: imageUrl)
                }
                self.userNameLabel.text = name
                self.lastMessagePreviewLabel.text = message.content
                self.timeLabel.text = message.time
            })
    }

}
