//
//  AvatarPickVC.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 10/16/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

enum AvatarType {
    case dark
    case light
}

protocol GetSelectedAvatarImageDelegate {
    func getSelectedAvatarImage(selectedImageName: String)
}

class AvatarPickVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var uiCollectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    // Variables
    var avatarType = AvatarType.dark
    var avatarNameDelegate: GetSelectedAvatarImageDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiCollectionView.delegate = self
        uiCollectionView.dataSource = self
        
        let gestureRescognizer = UITapGestureRecognizer()
        gestureRescognizer.addTarget(self, action: #selector(AvatarPickVC.tapToClose(_:)))
        backgroundView.addGestureRecognizer(gestureRescognizer)
        
    }
    
    @objc func tapToClose(_ gestureRecognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell {
            cell.configureCell(index: indexPath.row, type: avatarType)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            avatarType = .dark
        } else {
            avatarType = .light
        }
        
        uiCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfColumns: CGFloat = 3.0
        if UIScreen.main.bounds.width > 320 {
            numberOfColumns = 4
        }
        
        let spaceBetweenCells: CGFloat = 10
        let padding: CGFloat = 40
        let cellDimension = ((uiCollectionView.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarType == .dark {
            avatarNameDelegate.getSelectedAvatarImage(selectedImageName: "dark\(indexPath.item)")
        } else {
            avatarNameDelegate.getSelectedAvatarImage(selectedImageName: "light\(indexPath.item)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
