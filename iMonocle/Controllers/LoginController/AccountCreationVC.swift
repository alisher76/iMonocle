//
//  AccountCreationVC.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 8/28/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import Firebase

class AccountCreationVC: UIViewController {

    @IBOutlet weak var createAccountView: UIView!
    
    var delegate: MenuStaticTableVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRescognizer = UITapGestureRecognizer()
        gestureRescognizer.addTarget(self, action: #selector(AccountCreationVC.tapToClose(_:)))
        view.addGestureRecognizer(gestureRescognizer)
        
        createAccountView.layer.shadowOpacity = 1.0
        createAccountView.layer.shadowColor = UIColor.black.cgColor
        createAccountView.layer.shadowRadius = CGFloat(4.0)
        createAccountView.clipsToBounds = true
        createAccountView.backgroundColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tapToClose(_ gestureRecognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func twitterButtonTapped(_ sender: Any) {
        
    TwitterClient.sharedInstance?.login(success: {
        TwitterClient.sharedInstance?.currentAccount(success: { (twitterAccount) in
         FirebaseService.instance.loginUserToFirebase(withEmail: "\(twitterAccount.screenName)@monocle.com",password: "\(twitterAccount.uid)\(twitterAccount.name)", loginComplete: { (success, error) in
                if success {
                    print("Logged in")
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                    SavedStatus.instance.isLoggedIn = true
                    SavedStatus.instance.isLoggedInToTwitter = true
                    self.dismiss(animated: true, completion: nil)
                } else {
                    FirebaseService.instance.registerUserToFirebase(withEmail: "\(twitterAccount.screenName)@monocle.com", password: "\(twitterAccount.uid)\(twitterAccount.name)", name: "\(twitterAccount.name)", accountType: "twitter", token: SavedStatus.instance.twitterAuthToken, userCreationComplete: { (success, error) in
                        if success {
                            FirebaseService.instance.updateAccount(uid: (Auth.auth().currentUser?.uid)!, account: "twitter", userData: ["name": twitterAccount.name,
                                                      "id_str": twitterAccount.uid,
                                                      "screen_name": twitterAccount.screenName,
                                                      "friends-count": twitterAccount.followingCount,
                                                      "followers_count": twitterAccount.followerCount,
                                                      "description": twitterAccount.description,
                                                      "location": twitterAccount.location,
                                                      "profile_image_url_https": twitterAccount.image,
                                                      "accountType": twitterAccount.accountType
                                                      ])
                            NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            print("Created Account")
                            SavedStatus.instance.isLoggedIn = true
                            SavedStatus.instance.isLoggedInToTwitter = true
                            self.delegate?.loginLabel.text = "Logout"
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                    
                }
            })
            
        }, failure: { (error) in
            print(error)
        })
    }, failure: { (error) in
        print("Could not log in")
    })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
    }
    
    @IBAction func instagramButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardIdentifier.loginInstagramVC.rawValue) as! AuthInstagramViewController
        vc.registeringAccount = true
        self.present(vc, animated: true)
        
    }

}
