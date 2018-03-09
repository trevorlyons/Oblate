//
//  RoundedSideButton.swift
//  Oblate
//
//  Created by Trevor Lyons on 2018-03-08.
//  Copyright © 2018 Trevor Lyons. All rights reserved.
//

import UIKit

class RoundedSideButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 2
    }

}
