//
//  HomeSectionHeaderView.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/13/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class FriendsCollecViewController: UICollectionReusableView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    let imagesNames = ["add","Bonu1", "Buvijonim2", "Dadajonim1", "Do'dajonim1"]
    private let cellId = "friendsCell"
    lazy var collectionView1:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.yellow
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var collectionView2:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.yellow
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView1.register(FriendsCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView1)
       // addSubview(collectionView2)
        //addConstraintsWithFormat(format: "H:|[v1(20)]", views: collectionView2)
        // addConstraintsWithFormat(format: "V:|[v1(20)]", views: collectionView2)
         addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView1)
         addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView1)
        
    }
    
    func setUpCollectionView() {
        
    // left edge
        let leftColecctionView1Constraint = NSLayoutConstraint(item: collectionView1, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leadingMargin, multiplier: 1.0, constant: 0)
        self.addConstraints([leftColecctionView1Constraint])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FriendsCell
            cell.imageView.image = UIImage(named: imagesNames[indexPath.row])
            cell.tintColor = UIColor.white
            return cell
        } else if collectionView == collectionView2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenusCell
            cell.imageView.image = UIImage(named: imagesNames[indexPath.row])
            cell.tintColor = UIColor.white
            return cell
        }
        return collectionView.cellForItem(at: indexPath)!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  Utility.shared.CGSizeMake(frame.width/6, frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            showFriendsList()
        }
    }
    
    func showFriendsList() {
        print(123)
    }
}

class FriendsCell: BaseCell {
    
    var imageView:UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor.blue
        iv.layer.cornerRadius = 25
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

class MenusCell: BaseCell {
    
    var imageView:UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor.blue
        iv.layer.cornerRadius = 25
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

