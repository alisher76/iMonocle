//
//  AuthInstagramViewController.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/29/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class AuthInstagramViewController: UIViewController, UIWebViewDelegate  {
    
    @IBOutlet weak var webViewOutlet: UIWebView!
    var registeringAccount = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       webViewOutlet.delegate = self
       loadInitialData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func loadInitialData() {
        //InstagramApi.sharedInstance.startOAuth2Login()
        let url = URL(string: "https://api.instagram.com/oauth/authorize/?client_id=ac00ba2a3ad64cc8b4a180dcc5869e49&redirect_uri=https://www.imonocleMyApp.com&response_type=token")
        let request = URLRequest(url: url!)
        self.webViewOutlet.loadRequest(request)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        guard let urlDescription = request.url?.description else {return false}
        
        if urlDescription.contains("https://www.imonoclemyapp.com/#access_token=") {
            let token = urlDescription.replacingOccurrences(of: "https://www.imonoclemyapp.com/#access_token=", with: "")
            SavedStatus.instance.instagramAuthToken = token
            Instagram.instance.accessToken = token
            self.getUserInfo(token: token)
            SavedStatus.instance.isLoggedInToInstagram = true
            self.dismiss(animated: true, completion: nil)
        }
        return true
    }
    
    func createAccountWithInstagram(instaAccount: InstagramUser) {
        if !SavedStatus.instance.isLoggedInToTwitter && registeringAccount == false {
            FirebaseService.instance.loginUserToFirebase(withEmail: "\(instaAccount.userName)@monocle.com", password: "\(instaAccount.uid)", loginComplete: { (success, error) in
                if success {
                    print("logged in successfully")
                } else if !SavedStatus.instance.isLoggedInToTwitter && self.registeringAccount == true {
                    FirebaseService.instance.registerUserToFirebase(withEmail: "\(instaAccount.userName)@monocle.com", password: instaAccount.uid, name: instaAccount.fullName, accountType: "instagram", token: instaAccount.uid, userCreationComplete: { (success, error) in
                        if success {
                            print("Successfully created account")
                        }
                    })
                }
            })
        }
    }
    
    func getUserInfo(token: String) {
        
        let path = "https://api.instagram.com/v1/users/self/?access_token=\(token)"
        print(path)
        
        let request = URLRequest(url: URL(string: path)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, responce, error) in
            print(data.debugDescription)
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:[String:Any]] {
                        guard var userInfo = json["data"] else { return }
                        guard let instaAccount = InstagramUser(json: userInfo, accountType: "instagram") else { return }
                        userInfo["token"] = token
                        SavedStatus.instance.currentUserInstagramID = instaAccount.uid
                        
                        
                        FirebaseService.instance.loginUserToFirebase(withEmail: "\(instaAccount.userName)@monocle.com", password: "\(instaAccount.uid)", loginComplete: { (success, error) in
                            if success {
                                FirebaseService.instance.currentuserID = Auth.auth().currentUser?.uid
                                SavedStatus.instance.isLoggedInToInstagram = true
                                print("successFully logged in")
                            } else {
                                
                                if SavedStatus.instance.isLoggedInToTwitter {
                                    FirebaseService.instance.currentuserID = Auth.auth().currentUser?.uid
                                    FirebaseService.instance.updateAccount(uid: FirebaseService.instance.currentuserID!, account: "instagram", userData: userInfo)
                                    SavedStatus.instance.isLoggedInToInstagram = true
                                } else {
                                    
                                    FirebaseService.instance.registerUserToFirebase(withEmail: "\(instaAccount.userName)@monocle.com", password: instaAccount.uid, name: instaAccount.fullName, accountType: "instagram", token: token, userCreationComplete: { (success, error) in
                                        if success {
                                            print("Successfully created account")
                                            FirebaseService.instance.currentuserID = Auth.auth().currentUser?.uid
                                            FirebaseService.instance.updateAccount(uid: FirebaseService.instance.currentuserID!, account: "instagram", userData: userInfo)
                                            SavedStatus.instance.isLoggedInToInstagram = true
                                        }
                                    })
                                }
                                
                            }
                        })
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
