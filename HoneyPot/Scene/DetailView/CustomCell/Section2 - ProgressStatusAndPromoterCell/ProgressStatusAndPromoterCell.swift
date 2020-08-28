//
//  ProgressStatusAndPromoterCell.swift
//  Depromeet8th4
//
//  Created by Yeojaeng on 2020/08/03.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class ProgressStatusAndPromoterCell: UITableViewCell {
    @IBOutlet weak var honeyPotIcon: UIImageView!
    @IBOutlet weak var destDiscountPercent: UILabel!
    @IBOutlet weak var insufficientPersonCount: UILabel!
    @IBOutlet weak var discountGuideButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDiscountGuideButton()
    }

    func setupDiscountGuideButton() {
        discountGuideButton.backgroundColor = 0xF8F8F8.color
        discountGuideButton.layer.cornerRadius = 5
    }
}
