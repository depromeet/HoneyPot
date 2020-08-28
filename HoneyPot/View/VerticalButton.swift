//
//  VerticalButton.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/07/31.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class VerticalButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()

        let width = bounds.width
        let imageViewHeight = bounds.height / 5 * 3
        let labelHeight = bounds.height / 5 * 2
        let imageViewFrame = CGRect(x: 0, y: 0, width: width, height: imageViewHeight)
        let labelFrame = CGRect(x: 0, y: imageViewHeight, width: width, height: labelHeight)

        imageView?.frame = imageViewFrame
        titleLabel?.frame = labelFrame
    }
}
