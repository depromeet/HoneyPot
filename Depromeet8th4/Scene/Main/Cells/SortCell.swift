//
//  SortCell.swift
//  Depromeet8th4
//
//  Created by 최은지 on 2020/08/08.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import Then

class SortCell: UITableViewCell {

    var sortButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_expand_w24h24"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(sortButton)
        sortButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        sortButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
