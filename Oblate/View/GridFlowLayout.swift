//
//  GridFlowLayout.swift
//  Oblate
//
//  Created by Trevor Lyons on 2018-03-04.
//  Copyright © 2018 Trevor Lyons. All rights reserved.
//

import UIKit

class GridFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        minimumLineSpacing = 5.0
        minimumInteritemSpacing = 1.0
        scrollDirection = .vertical
    }
    
    override var itemSize: CGSize {
        set {}
        get {
            let numberOfColumns: CGFloat = 3
            let desiredSpacing: CGFloat = 5
            let numberOfItemSpaces: CGFloat = numberOfColumns - 1
            let itemWidth = (self.collectionView!.frame.width - (desiredSpacing * numberOfItemSpaces)) / numberOfColumns
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
}
