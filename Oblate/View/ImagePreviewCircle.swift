//
//  ImagePreviewCircle.swift
//  Oblate
//
//  Created by Trevor Lyons on 2018-02-24.
//  Copyright © 2018 Trevor Lyons. All rights reserved.
//

import UIKit

class ImagePreviewCircle: UIImageView {

    override func awakeFromNib() {
        
        layer.cornerRadius = self.frame.width / 2
        
        layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 0.8
        
        let opacity: CGFloat = 0.5
        let borderColor = UIColor.white
        layer.borderWidth = 2
        layer.borderColor = borderColor.withAlphaComponent(opacity).cgColor
        
    }

}
