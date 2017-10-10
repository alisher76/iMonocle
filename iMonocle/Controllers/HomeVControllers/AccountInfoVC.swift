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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

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
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as? AccountInfoCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = UIImage(named: imageNames[indexPath.row])
        return cell
    }
}

class AccountInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
    
    
}
