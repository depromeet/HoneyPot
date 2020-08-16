//
//  ProductImageCell.swift
//  Depromeet8th4
//
//  Created by Yeojaeng on 2020/08/03.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class ProductImageCell: UITableViewCell {
    @IBOutlet var photoView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    func setupCategoryLabelUI() {
        categoryLabel.layer.cornerRadius = 3
        categoryLabel.clipsToBounds = true
    }
}
