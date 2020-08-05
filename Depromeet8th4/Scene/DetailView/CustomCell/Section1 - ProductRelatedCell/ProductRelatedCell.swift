//
//  ProductRelatedCell.swift
//  Depromeet8th4
//
//  Created by Yeojaeng on 2020/08/03.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class ProductRelatedCell: UITableViewCell {
    //MARK:- Properties
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var discountRate: UILabel!
    @IBOutlet weak var discountedPrice: UILabel!
    @IBOutlet weak var personEmoticon: UIImageView!
    @IBOutlet weak var timeEmoticon: UIImageView!
    @IBOutlet weak var participantsCount: UILabel!
    @IBOutlet weak var deadLine: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
