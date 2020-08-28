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
    @IBOutlet weak var categoryView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCategoryView()
    }

    func setupCategoryView() {
        categoryView.layer.cornerRadius = 5
        categoryView.backgroundColor = 0xFFFFFF.color
    }
}
