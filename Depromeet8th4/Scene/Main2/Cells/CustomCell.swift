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
        $0.text = "tab"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        $0.textColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override var isSelected: Bool {
        didSet {
            print("selected!")
            self.tabLabel.textColor = isSelected ? .black : .lightGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(tabLabel)
        tabLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        tabLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

}
