//
//  PostsCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 10/10/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class PostsCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: HomeVC?
    let isClosedColumns: CGFloat = 1.0
    let isOpenColumns: CGFloat = 1.0
    let inset: CGFloat = 5.0
    
    var monoclePosts = [MonoclePost]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
       
    }
}

extension PostsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: number of items in section
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monoclePosts.count
    }
    
    // MARK: cell for item at indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "instaPostCell", for: indexPath) as? InstaPostCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(post: monoclePosts[indexPath.row])
        return cell
    }
    
    // MARK: did slect item at index path
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if (delegate?.isOpen)! {
//            delegate?.isOpen = false
//        } else {
//            delegate?.isOpen = true
//        }
//        delegate?.mainTableView.reloadData()
//        collectionView.reloadData()
    }
    
    
    // MARK: Size for item at
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.frame.width, height: (delegate?.view.frame.size.height)! / 1.8)
        
    }
    // MARK: spacing between successive rows or columns of the section
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}
