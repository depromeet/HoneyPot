//
//  MenuCell.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/07/31.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import SnapKit
import Then

class MenuCell: BaseTableViewCell {
    let imageViewIcon = UIImageView().then {
        $0.image = nil
    }
    let labelTitle = UILabel().then {
        $0.textColor = 0x323232.color
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
    }

    override func initialize() {
        setupViews()
    }

    private func setupViews() {
        selectionStyle = .none
        addSubview(imageViewIcon)
        imageViewIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
        }
        addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.leading.equalTo(imageViewIcon.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
    }
}
