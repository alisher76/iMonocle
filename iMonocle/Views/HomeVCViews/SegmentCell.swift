//
//  SegmentCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 10/10/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class SegmentCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var segmentMenuImages = ["iMonocle", "twitter", "instagram", "more"]
    var delegate: HomeVC?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension SegmentCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "segmentCollectionViewCell", for: indexPath) as! SegmentMenuCollectionViewCell
        cell.layer.shadowOpacity = 0
        cell.segmentImage.layer.opacity = 0.5
        cell.segmentImage.image = UIImage(named: segmentMenuImages[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            delegate?.selectedOption = .monocle
        case 1:
            delegate?.selectedOption = .twitter
        case 2:
            delegate?.selectedOption = .instagram
        case 3:
            delegate?.selectedOption = .more
        default:
            delegate?.selectedOption = .monocle
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.size.width / 4) - 10, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
}

class SegmentMenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var segmentImage: UIImageView!
    
    override func awakeFromNib() {

    }
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                segmentImage.layer.opacity = 1
                self.layer.cornerRadius = 20
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOffset = CGSize(width:0,height: 4.0)
                self.layer.shadowRadius = 10.0
                self.layer.shadowOpacity = 1.0
                self.layer.masksToBounds = false
            } else {
                self.layer.shadowOpacity = 0
                self.segmentImage.layer.opacity = 0.5
            }
        }
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
    }}
