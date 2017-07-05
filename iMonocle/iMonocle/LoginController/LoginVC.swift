//
//  LoginVC.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/5/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit


class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func twitterButtonLogin(_ sender: Any) {
        TwitterClient.sharedInstance?.login(success: {
            print("Logged In")
            
        }) { (error) in
            print(error)
        }
    }

}
