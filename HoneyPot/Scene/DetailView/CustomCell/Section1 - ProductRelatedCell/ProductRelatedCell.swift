//
//  ProductRelatedCell.swift
//  Depromeet8th4
//
//  Created by Yeojaeng on 2020/08/03.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class ProductRelatedCell: UITableViewCell {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var discountRate: UILabel!
    @IBOutlet weak var discountedPrice: UILabel!
    @IBOutlet weak var priceBarView: UIView!
    override func awakeFromNib() {
        setupPriceBarView()
    }

    func setupPriceBarView() {
        priceBarView.backgroundColor = 0xA5A5A5.color
    }
}
