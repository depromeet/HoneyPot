//
//  ProgressStatusAndPromoterCell.swift
//  Depromeet8th4
//
//  Created by Yeojaeng on 2020/08/03.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class ProgressStatusAndPromoterCell: UITableViewCell {
    //MARK:- Properties
    @IBOutlet weak var honeyPotIcon: UIImageView!
    @IBOutlet weak var participantsCount: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var promoterImage: UIImageView!
    @IBOutlet weak var destParticipantCount: UILabel!
    @IBOutlet weak var protomerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
