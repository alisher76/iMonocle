//
//  AuthInstagramViewController.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/29/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import Alamofire

class AuthInstagramViewController: UIViewController, UIWebViewDelegate  {
    
     @IBOutlet weak var webViewOutlet: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       webViewOutlet.delegate = self
       loadInitialData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let token = (urlDescription.replacingOccurrences(of: "https://www.imonoclemyapp.com/#access_token=", with: ""))
            print(token)
            getUserInfo(token: token)
        }
        return true
    }
    
    func getUserInfo(token: String) {
        
        let path = "https://api.instagram.com/v1/users/self/?access_token=\(token)"
        
        request(URL(string: path)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (responce) in
            print(responce.value as Any)
        }
        
    }

}
