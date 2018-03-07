//
//  GalleryCell.swift
//  Oblate
//
//  Created by Trevor Lyons on 2018-03-05.
//  Copyright © 2018 Trevor Lyons. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var galleryImage: UIImageView!
    
    func configureCell(thumb: Image) {
        galleryImage.image = thumb.type as? UIImage
    }

}
