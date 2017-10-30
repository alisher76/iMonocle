//
//  AddAccountVC.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/4/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

private let cellID = "AddAccountVCCell"

class AddAccountVC: UIViewController {

    // Mark: Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var monocleUser = [MonocleUser]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        
        let gestureRescognizer = UITapGestureRecognizer()
        gestureRescognizer.addTarget(self, action: #selector(AccountCreationVC.tapToClose(_:)))
        backgroundView.addGestureRecognizer(gestureRescognizer)
        
        collectionView.register(AccountCell.self, forCellWithReuseIdentifier: cellID)
        
        getInstagramFriendsList()
    }
    
    // Mark: Get Insta Friends
    func getInstagramFriendsList() {
        if let accessToken = Instagram().userDefaults.object(forKey: INSTAGRAM_TOKEN_KEY) as? String {
            Instagram().fetchUserFriends(accessToken) { (users) in
                for instagramUser in users {
                    self.monocleUser.append(MonocleUser.instagramUser(instagramUser))
                }
            }
        }
    }
}

extension AddAccountVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if monocleUser.count != 0 {
            return monocleUser.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AccountCell
        cell.setupCell(friend: monocleUser[indexPath.row])
        return cell
    }
    
    @objc func tapToClose(_ gestureRecognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Create an option menu as an action sheet
        let optionMenu = UIAlertController(title: nil, message: "Add the account to user?", preferredStyle: .actionSheet)
        
        // Add actions to the menu
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            FirebaseService.instance.updateSelectedFriendAccount(selectedUser: FirebaseService.instance.selectedUser!, monocleUser: self.monocleUser[indexPath.row])
            self.dismiss(animated: true, completion: nil)
        }
        optionMenu.addAction(addAction)
        
        // Display the menu
        present(optionMenu, animated: true, completion: nil)
    }
}

class AccountCell: BaseCell {
    
    // Mark: Outlets
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile-icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Alisher A"
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@alisherTwitter"
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupViews() {
        backgroundColor = UIColor.white
        addSubview(profileImageView)
        addSubview(seperatorView)
        addSubview(nameLabel)
        addSubview(userNameLabel)
        
        
        addConstraintsWithFormat(format: "H:|-25-[v0(45)]-5-[v1]|", views: profileImageView, nameLabel)
        addConstraintsWithFormat(format: "H:|-75-[v0]|", views: userNameLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: seperatorView)
        addConstraintsWithFormat(format: "V:|-5-[v0(45)]|", views: profileImageView)
        addConstraintsWithFormat(format: "V:|-5-[v0(20)]-2-[v1(15)]-5-[v2(1)]|", views: nameLabel, userNameLabel, seperatorView)
        
    }
    
    func setupCell(friend: MonocleUser) {
        
        switch friend {
        case .instagramUser(let iUser):
            self.profileImageView.downloadedFrom(link: iUser.image)
            self.nameLabel.text = iUser.fullName
            self.userNameLabel.text = iUser.userName
        case .twitterUser(let tUser):
            self.profileImageView.downloadedFrom(link: tUser.image)
            self.nameLabel.text = tUser.name
            self.userNameLabel.text = tUser.screenName
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? UIColor.blue : UIColor.white
            switch FirebaseService.instance.selectedUser! {
            case .instagramUser(let user):
                print("\(user.fullName)")
            case .twitterUser(let user):
                print("\(user.name)")}
        }
    }
    
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = UIColor.blue
    }
}

