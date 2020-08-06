//
//  PageCell.swift
//  Depromeet8th4
//
//  Created by 최은지 on 2020/08/06.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import Then

class PageCell: UICollectionViewCell {

    var label = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(label)
        self.backgroundColor = .white
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

}
