//
//  SearchCell.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/08.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import SnapKit
import Then

class SearchCell: BaseTableViewCell {
    let labelTitle = UILabel().then {
        $0.textColor = 0x323232.color
        $0.font = .systemFont(ofSize: 16)
    }
    let buttonClose = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_close_w10h10"), for: .normal)
    }

    override func initialize() {
        setupViews()
    }

    private func setupViews() {
        selectionStyle = .none
        addSubview(buttonClose)
        buttonClose.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
            $0.width.equalTo(buttonClose.snp.height)
        }
        addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.equalTo(buttonClose).offset(10)
            $0.centerY.equalToSuperview()
        }
    }
}
