//
//  SortCell.swift
//  Depromeet8th4
//
//  Created by 최은지 on 2020/08/08.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Then
import UIKit

class SortCell: UITableViewCell {
    let sortButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_expand_w24h24"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let sortLabel = UILabel().then {
        $0.text = "최신순"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        addSubview(sortButton)
        sortButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sortButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.1).isActive = true

        addSubview(sortLabel)
        sortLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sortLabel.trailingAnchor.constraint(equalTo: sortButton.leadingAnchor).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
