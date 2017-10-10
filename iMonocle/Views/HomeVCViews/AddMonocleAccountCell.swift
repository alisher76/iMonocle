//
//  AddMonocleAccountCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 10/10/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class AddMonocleAccountCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImage: CircleImage!
    @IBOutlet weak var nameLabel: UILabel!
    
    var delegate: HomeVC?
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if !SavedStatus.instance.isLoggedInToInstagram {
            self.loginInstagramVC()
        } else {
            let addAccountVC = AddAccountVC()
            addAccountVC.modalPresentationStyle = .custom
            delegate?.present(addAccountVC, animated: true, completion: nil)
        }
    }
    
    func setupCell(user: MonocleUser) {
        switch user {
        case .instagramUser(let instagramUser):
            nameLabel.text = instagramUser.fullName
            descriptionLabel.text = "has no Twitter Account, would you like to add?"
        case .twitterUser(let twitterUser):
            nameLabel.text = twitterUser.name
            descriptionLabel.text = "has no instagtam account would you like to add?"
        }
    }
    
    func loginInstagramVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardIdentifier.loginInstagramVC.rawValue) as! AuthInstagramViewController
        vc.registeringAccount = false
        delegate?.present(vc, animated: true)
    }

}
