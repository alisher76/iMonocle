//
//  Protocols.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/12/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation

protocol MosaicLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat
}

protocol MenuCellDelegate: class {
    func didPressButton(_ tag: Int)
}
