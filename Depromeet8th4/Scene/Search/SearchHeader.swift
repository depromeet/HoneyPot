//
//  SearchHeader.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/08.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class SearchHeader: BaseTableViewHeader {
    let viewContainer = UIView().then {
        $0.backgroundColor = .systemBackground
    }
    let labelTitle = UILabel().then {
        $0.textColor = 0x323232.color
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    let buttonDelete = UIButton().then {
        $0.setTitle("전체삭제", for: .normal)
        $0.setTitleColor(0xA5A5A5.color, for: .normal)
        $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    }
    let viewSeparator = UIView().then {
        $0.backgroundColor = 0xEEEEEE.color
    }

    override func initialize() {
        setupViews()
    }

    private func setupViews() {
        addSubview(viewContainer)
        viewContainer.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(51)
        }
        viewContainer.addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview().offset(1)
        }
        viewContainer.addSubview(buttonDelete)
        buttonDelete.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview().offset(3)
        }
        addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.top.equalTo(viewContainer.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(9)
            $0.height.equalTo(1)
        }
    }
}
