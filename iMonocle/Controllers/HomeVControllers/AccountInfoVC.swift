//
//  AccountInfoVC.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/28/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class AccountInfoVC: UIViewController {

    @IBOutlet weak var topImageView: CircleImage!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundView: UIView!
    
    var imageNames = [String]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var twitterAccount: TwitterUser?
    var instagramUser: InstagramUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = 10.0
        collectionView.layer.shadowColor = UIColor.darkGray.cgColor
        collectionView.layer.shadowOffset = CGSize(width:0,height: 1.0)
        collectionView.layer.shadowRadius = 2.0
        collectionView.layer.shadowOpacity = 1.0
        collectionView.layer.masksToBounds = false
        let gestureRescognizer = UITapGestureRecognizer()
        gestureRescognizer.addTarget(self, action: #selector(SelectMonocleUserVC.tapToClose(_:)))
        backgroundView.addGestureRecognizer(gestureRescognizer)
        checkDataBase()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkDataBase()
        setup()
    }
    
    @objc func tapToClose(_ gestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setup() {
        switch FirebaseService.instance.selectedUser! {
        case .instagramUser(let iUser):
            topImageView.downloadedFrom(link: iUser.image)
        case .twitterUser(let tUser):
            topImageView.downloadedFrom(link: tUser.image)
        }
    }
    
    func checkDataBase() {
        
        if FirebaseService.instance.isCurrentUser(user: FirebaseService.instance.selectedUser!) {
            FirebaseService.instance.checkCurrentUserAccount(user: FirebaseService.instance.selectedUser!) { (has) in
                if has == "both" {
                    self.imageNames = ["instagram-filled", "twitter-filled"]
                } else if has == "instagram" {
                    self.imageNames = ["instagram-filled", "twitter"]
                } else {
                    self.imageNames = ["instagram", "twitter-filled"]
                }
            }
        } else {
            FirebaseService.instance.checkAccounts(monocleUser: FirebaseService.instance.selectedUser!, hasAccount: { (has) in
                if has == "both" {
                    self.imageNames = ["instagram-filled", "twitter-filled"]
                } else if has == "instagram" {
                    self.imageNames = ["instagram-filled", "twitter"]
                } else {
                    self.imageNames = ["instagram", "twitter-filled"]
                }
            })
        }
    }
}

extension AccountInfoVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if FirebaseService.instance.monocleAccount.count != 0 {
            return FirebaseService.instance.monocleAccount.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as? AccountInfoCell else {
            return UICollectionViewCell()
        }
        //cell.imageView.image = UIImage(named: imageNames[indexPath.row])
        if FirebaseService.instance.monocleAccount.count != 0 {
            if FirebaseService.instance.monocleAccount.count == 2 {
                cell.disconnectBtn.isHidden = false
                cell.disconnectBtn.isEnabled = true
            } else {
                cell.disconnectBtn.isHidden = true
                cell.disconnectBtn.isEnabled = false
            }
            cell.setup(monocleUser: FirebaseService.instance.monocleAccount[indexPath.row])
        }
        return cell
    }
}

class AccountInfoCell: UICollectionViewCell {
    
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var accountNameLabel: UILabel!
    @IBOutlet var disconnectBtn: RoundedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(monocleUser: MonocleUser) {
        switch monocleUser {
        case .instagramUser(let instagram):
            statusLabel.text = instagram.fullName
            imageView.downloadFrom(url: URL(string: instagram.image)!)
            nameLabel.text = instagram.userName
            accountNameLabel.text = instagram.accountType
            
        case .twitterUser(let twitter):
            statusLabel.text = twitter.description
            imageView.downloadFrom(url: URL(string: twitter.image)!)
            nameLabel.text = twitter.name
            accountNameLabel.text = twitter.accountType
            
        }
    }
    @IBAction func disconnectBtnTapped(_ sender: Any) {
        
    }
}
