//
//  HomeViewController.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/13/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

private let menuReuseIdentifier = "menuCell"
private let feedReuseIdentifier = "feedCell"
private let tweetReuseIdentifier = "tweetCell"
private let friendsReuseIdentifier = "friendsCell"

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    // collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
     setupMenuBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: UICollectionViewDataSource
    
    let imagesNames = ["ali", "FullSizeRender 4", "papass", "Bonu1"]
    let textLabels = ["Create an outlet for both the image and label. Name the label one lblCell and the image one imgCell.   Once this is done close down the split view and open Viewcontroller.swift.","Now under class view controller add two arrays as follows – tableData stores the names of cars & tableImage stores image names  of the cars. You will need to have some .jpg images names exactly", "If you rotate the phone the collection view will also adapt to the new layout, it will also adapt to different sized devices. If you wish to test this simply add more items in the tableData & tableImages array to fill up the screen with items in the cells.", "Andrew is a 24 year old from Sydney. He loves developing iOS apps and has done so for two years."]
    let names = ["alisher", "Ali", "Yorqin", "Bonu"]
    
    func setupMenuBar()  {
        let menuImage = UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal)
        let menuBarButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(handleMenu))
        navigationItem.leftBarButtonItem = menuBarButton
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return imagesNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuReuseIdentifier, for: indexPath) as! SegmentControlCell
             return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedReuseIdentifier, for: indexPath) as! FeedsCell
           // cell.descriptionTextView.text = textLabels[indexPath.row]
            cell.profileImage.image = UIImage(named: imagesNames[indexPath.row])
            cell.nameLabel.text = names[indexPath.row]
            cell.userNameLabel.text = "@\(names[indexPath.row])"
            cell.postImageView.image = UIImage(named: imagesNames[indexPath.row])
            cell.layer.cornerRadius = 3
            return cell
            
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tweetReuseIdentifier, for: indexPath) as! TweetCell
//            cell.descriptionTextView.text = textLabels[indexPath.row]
//            cell.profileImageView.image = UIImage(named: imagesNames[indexPath.row])
//            cell.nameLabel.text = names[indexPath.row]
//            cell.userNameLabel.text = "@\(names[indexPath.row])"
//            cell.mediaImageView.image = UIImage(named: imagesNames[indexPath.row])
//            cell.layer.cornerRadius = 3
//            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "friendsCell", for: indexPath) as! FriendsCollecViewController
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: view.frame.width, height: 50)
        } else {
            return CGSize(width: view.frame.width - 30, height: 350)
        }
    }
    
    @objc func handleMenu() {
        print("HandleMenu")
    }
    
}

extension UIView {
    func addConstraintsWithFormat(format:String, views: UIView...){
        
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
            
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}



