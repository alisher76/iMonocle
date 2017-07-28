//
//  LoginVC.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/5/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import Firebase
import FirebaseDatabase

class LoginVC: UIViewController {
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let accessToken = userDefault.object(forKey: "twitterAccessToken") as? String
        
//        if Auth.auth().currentUser != nil {
//            if accessToken != nil {
//                self.showFriendsSelectionVC() }
//        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func twitterButtonLogin(_ sender: Any) {
        TwitterClient.sharedInstance?.login(success: {
            TwitterClient.sharedInstance?.currentAccount(success: { (succes) in
                FirebaseService.sigIn(email: "\(succes.screenName)@monocle.com", password: succes.uid)
            }, failure: { (error) in
                print(error)
            })
        }, failure: { (error) in
            print("Could not log in")
        })
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    func showFriendsSelectionVC() {
        let storyboard = UIStoryboard(name: "Starter", bundle: nil)
        let showFriendsViewController = storyboard.instantiateViewController(withIdentifier: "FriendsSelectionVC") as! FriendsSelectionViewController
        showFriendsViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.show(showFriendsViewController, sender: self)
    }
}
