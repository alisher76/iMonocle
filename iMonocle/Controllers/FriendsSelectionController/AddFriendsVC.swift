//
//  AddFriendsVC.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 8/29/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class AddFriendsVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var monocleUser = [MonocleUser]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var currentSelectedFriends = [String:MonocleUser]() {
        didSet {
            print(currentSelectedFriends.count)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        tableView.separatorColor = .clear
        checkDataBase()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseService.instance.checkInitialSignedInSMediaType { (accountType) in
            if accountType == "twitter" {
                self.monocleUser.removeAll()
                self.checkDataBase()
                TwitterClient.sharedInstance?.getListOfFollowedFriends(success: { (friends) in
                    self.monocleUser = friends
                }, failure: { (error) in
                    print(error.localizedDescription)
                })
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func twitterButtonTapped(_ sender: Any) {
        monocleUser.removeAll()
        checkDataBase()
        TwitterClient.sharedInstance?.getListOfFollowedFriends(success: { (friends) in
            self.monocleUser = friends
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }
    
    @IBAction func instagramButtonTapped(_ sender: Any) {
        print("InstagramTapped")
        monocleUser.removeAll()
        getInstagramFriendsList()
    }
    
    func getInstagramFriendsList() {
        
        if let accessToken = Instagram().userDefaults.object(forKey: "instagramToken") as? String {
            Instagram().fetchUserFriends(accessToken) { (users) in
                var usersArray: [MonocleUser] = []
                for instagramUser in users {
                    usersArray.append(MonocleUser.instagramUser(instagramUser))
                }
                self.monocleUser = usersArray
            }
        } else {
            //login
            loginInstagramVC()
        }
    }
    func loginInstagramVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginInstagramVC") as! AuthInstagramViewController
        self.show(vc, sender: self)
    }
    
}

extension AddFriendsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if monocleUser.count > 0 {
            return monocleUser.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addFriendCell", for: indexPath) as? AddFriendCell else {
            return UITableViewCell()
        }
        cell.currentSelectedFriends = currentSelectedFriends
        cell.setupCell(friend: monocleUser[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
               cell.accessoryType = .none
            switch monocleUser[indexPath.row] {
            case .instagramUser(let insagramUser):
                print("\(insagramUser.fullName)")
                
            case .twitterUser(let twitterUser):
                guard let selectedMonocleUser = currentSelectedFriends[twitterUser.name] else { return }
                FirebaseService.instance.removeFromFriendsList(monocleUser: selectedMonocleUser)
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
            } else {
            cell.accessoryType = .checkmark
            FirebaseService.instance.updateFriendsCollection(monocleUser: monocleUser[indexPath.row])
            NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        }
    }
    
    func checkDataBase() {
        FirebaseService.instance.currentListOfFriends { (success) in
            self.currentSelectedFriends = success
        }
    }
    
}
