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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
