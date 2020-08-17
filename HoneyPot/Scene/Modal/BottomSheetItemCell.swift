//
//  BottomSheetItemCell.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/16.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class BottomSheetItemCell: BaseTableViewCell {
    private enum Color {
        static let normalTitle = 0xA5A5A5.color
        static let selectedTitle = 0x323232.color
    }
    private enum Font {
        static let normalTitle = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        static let selectedTitle = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
    }

    let labelTitle = UILabel().then {
        $0.textColor = Color.normalTitle
        $0.font = Font.normalTitle
    }
    let imageViewCheck = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "image_item_checked_w24h24")
        $0.isHidden = true
    }

    override func initialize() {
        selectionStyle = .none
        addSubview(imageViewCheck)
        imageViewCheck.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview().offset(-1)
        }
        addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.leading.equalTo(imageViewCheck.snp.trailing).offset(16)
            $0.centerY.equalTo(imageViewCheck)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            labelTitle.textColor = Color.selectedTitle
            labelTitle.font = Font.selectedTitle
        } else {
            labelTitle.textColor = Color.normalTitle
            labelTitle.font = Font.normalTitle
        }
        imageViewCheck.isHidden = !selected
    }
}
