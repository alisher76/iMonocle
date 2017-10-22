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
    
    var segmentMenuImages = ["Monocle", "twitter", "Instagram", "more"]
    var selectedMenu = ["MonocleFilled", "twitterFilled", "instagram Filled", "more Filled"]
    var selectedImageName = "Monocle"
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
        cell.delegate = self
        cell.layer.shadowOpacity = 0
        cell.segmentImage.layer.opacity = 0.5
        switch (delegate?.selectedOption)! {
        case .monocle:
            cell.segmentImage.image = UIImage(named: selectedMenu[indexPath.row])
        case .instagram:
            cell.segmentImage.image = UIImage(named: selectedMenu[indexPath.row])
        case .twitter:
            cell.segmentImage.image = UIImage(named: selectedMenu[indexPath.row])
        case .more:
            cell.segmentImage.image = UIImage(named: selectedMenu[indexPath.row])
        }
        cell.segmentImage.image = UIImage(named: segmentMenuImages[indexPath.row])
        cell.animateSegmentCell()
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
        return CGSize(width: (self.frame.size.width / 4) - 10, height: 30)
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
    var delegate: SegmentCell!
    
    override func awakeFromNib() {
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
    }
    
    func setup(name: String) {
        segmentImage.image = UIImage(named: name)
    }
}
