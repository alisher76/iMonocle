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

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func twitterButtonLogin(_ sender: Any) {
        TwitterClient.sharedInstance?.login(success: {
            TwitterClient.sharedInstance?.currentAccount(success: { (succes) in
                Auth.auth().signIn(withEmail: "\(succes.screenName)@monocle.com", password: succes.uid) { (user, error) in
                    if error == nil {
                        // Go to app
                        print("Already signed in")
                    } else {
                        Auth.auth().createUser(withEmail: "\(succes.screenName)@monocle.com", password: succes.uid, completion: { (user, error) in
                            if error != nil {
                                print("Could not sign in")
                            } else {
                                // go to app
                            }
                        })
                    }
                }
            }, failure: { (error) in
                print(error)
            })
        }, failure: { (error) in
            print("Could not log in")
        })
    }

}
