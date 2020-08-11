//
//  ResizableTableView.swift
//  KiTPlayer
//
//  Created by Soso on 04/11/2019.
//  Copyright © 2019 Muzlive. All rights reserved.
//

import UIKit

class ResizableTableView: UITableView {
    var maxHeight: CGFloat = 300

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
