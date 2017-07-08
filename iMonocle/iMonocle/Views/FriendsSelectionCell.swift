//
//  FriendsSelectionCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/7/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class FriendsSelectionCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var userNamelabel: UILabel!
    
    var twitterUser: TwitterUser! {
        didSet {
            cellConfigure(name: twitterUser.name, userName: twitterUser.screenName, profileImage: twitterUser.image)
        }
    }
    
    var instagramUser: InstagramUser! {
        didSet {
            cellConfigure(name: instagramUser.fullName, userName: instagramUser.userName, profileImage: instagramUser.image)
        }
    }
    
    var monocleUser: MonocleUser! {
        didSet {
            switch monocleUser {
            case .some(.instagramUser(let value)):
                instagramUser = value
              //  tweetSetConfigure()
            case .some(.twitterUser(let value)):
                twitterUser = value
               // instaPostSetConfigure()
            case .none:
                print("something went wrong")
            }
        }
    }
    
    func cellConfigure(name: String, userName: String, profileImage: String) {
            guard let url = URL(string: profileImage) else {return}
            let data = try? Data(contentsOf: url)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                self.profileImage.image = image
            }
            namelabel.text = name
            userNamelabel.text = userName
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImage.image = nil
        namelabel.text = ""
        userNamelabel.text = ""
    }
}
