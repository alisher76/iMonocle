//
//  FriendsCollecViewController.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/13/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class FriendsCollecViewController: UICollectionReusableView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    var friends = [MonocleUser]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let cellId = "friendsCell"
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.lightText
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(FriendsCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        
         addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
         addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FriendsCell
        
        if indexPath.row == 0 {
            cell.imageView.image = UIImage(named: "add")
        } else {
            switch friends[indexPath.row - 1] {
            case .instagramUser(let value):
                cell.imageView.downloadedFrom(link: value.image)
            case .twitterUser(let value):
                cell.imageView.downloadedFrom(link: value.image)
            }
        }
        cell.tintColor = UIColor.white
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  Utility.shared.CGSizeMake(frame.width/6, frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            showFriendsList(index: indexPath.item)
        } else {
            print(indexPath.row)
        }
    }
    
    func showFriendsList(index: Int) {
        print(index)
    }
}

class FriendsCell: BaseCell {
    
    var imageView:UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor.blue
        iv.layer.cornerRadius = 25
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.borderWidth = 1
        iv.clipsToBounds = true
        return iv
    }()
    
    override var isHighlighted: Bool{
        didSet{
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.blue
        }
    }
    
    override var isSelected: Bool{
        didSet{
            imageView.tintColor = isSelected ? UIColor.white : UIColor.darkGray
        }
    }
    
   override func setUpViews() {
       super.setUpViews()
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(50)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}

class BaseCell:UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews(){
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

