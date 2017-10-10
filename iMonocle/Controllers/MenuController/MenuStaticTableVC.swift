//
//  MenuStaticTableVC.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/22/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import Firebase

class MenuStaticTableVC: UITableViewController {

    @IBOutlet weak var profileImageView: CircleImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    
    var monocleUser: MonocleUser? {
        didSet {
            if monocleUser != nil {
                switch monocleUser! {
                case .twitterUser(let twitterUser):
                    nameLabel.text = twitterUser.name
                    userNameLabel.text = twitterUser.screenName
                    profileImageView.downloadedFrom(link: twitterUser.image)
                case .instagramUser(let instagramUser):
                    nameLabel.text = instagramUser.fullName
                    userNameLabel.text = instagramUser.userName
                    profileImageView.downloadedFrom(link: instagramUser.image)
                }
            } else {
                nameLabel.text = "iMono"
                userNameLabel.text = "@iMonoUser"
                profileImageView.image = UIImage(named: "profile-icon")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 100        
        NotificationCenter.default.addObserver(self, selector: #selector(MenuStaticTableVC.updateMenu), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        updateMenu()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            // Go Home Page
            print("HomePageTapped")
        case 1:
            print("HomePageTapped")
        case 2:
            print("HomePageTapped")
        case 3:
            self.handleLogin()
        default:
            break
        }
    }
    
    @objc fileprivate func updateMenu() {
        // Get userinfo and update view
                if SavedStatus.instance.isLoggedIn {
                    loginLabel.text = "Logout"
                    FirebaseService.instance.getCurrentUserInfo { (user) in
                        self.monocleUser = user
                    }
                } else {
                    loginLabel.text = "Login"
                }
    }
    
    fileprivate func handleLogin() {
            if loginLabel.text == "Logout" {
                FirebaseService.instance.logout()
                SavedStatus.instance.isLoggedIn = false
                monocleUser = nil
                FirebaseService.instance.currentUser = nil
                SavedStatus.instance.cleanUpSavedStatus()
                loginLabel.text = "Login"
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        } else {
            if loginLabel.text == "Login" {
                let loginVC = AccountCreationVC()
                loginVC.modalPresentationStyle = .custom
                loginVC.delegate = self
                self.present(loginVC, animated: true, completion: nil)
            
                }
        }
    }
}
