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
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupCategoryLabelUI() {
        // CategoryLabel Radius
        categoryLabel.layer.cornerRadius = 3
        categoryLabel.clipsToBounds = true
    }
}
