//
//  HomeViewController.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/13/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let reuseIdentifier2 = "FeedCell"

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     navigationItem.title = "Home"
    // collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
     setupMenuBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: UICollectionViewDataSource
    
    var example = [2,3,23,2,3,2,23,2,2,3,23,23,23,23]
    
    var pictures = [#imageLiteral(resourceName: "Bonu1.jpg"),#imageLiteral(resourceName: "Buvijonim2.jpg"),#imageLiteral(resourceName: "Dadajonim1.jpg"),#imageLiteral(resourceName: "Do'dajonim1.jpg")]
    
    func setupMenuBar()  {
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return example.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCell
             return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) as! FeedsCell
            
            cell.feedTextLabel.text = "\(example[indexPath.row])"
             return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MenuBar", for: indexPath) as! HomeSectionHeaderView
        return sectionHeaderCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
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



