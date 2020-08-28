//
//  FunctionCell.swift
//  Depromeet8th4
//
//  Created by Yeojaeng on 2020/08/05.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class FunctionCell: UITableViewCell {
    @IBOutlet weak var participateButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButtonUI()
    }

    func setupButtonUI() {
        participateButton.layer.cornerRadius = 5
        participateButton.backgroundColor = 0xFFC500.color
    }
}
