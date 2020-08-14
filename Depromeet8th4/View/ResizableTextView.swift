//
//  ResizableTextView.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/14.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class ResizableTextView: UITextView {
    var maxHeight: CGFloat = 67

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        var height: CGFloat
        if maxHeight != 0 {
            height = min(contentSize.height, maxHeight)
        } else {
            height = contentSize.height
        }
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        invalidateIntrinsicContentSize()
    }
}
