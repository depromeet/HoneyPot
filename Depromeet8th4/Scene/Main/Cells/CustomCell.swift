//
//  CustomCell.swift
//  Depromeet8th4
//
//  Created by 최은지 on 2020/08/06.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import Then

class CustomCell: UICollectionViewCell {

    var tabLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "color_unselect")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.tabLabel.textColor = UIColor(named: "color_select")
                self.tabLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            } else {
                self.tabLabel.textColor = UIColor(named: "color_unselect")
                self.tabLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(tabLabel)
        tabLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        tabLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

}
