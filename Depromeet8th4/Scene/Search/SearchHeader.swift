//
//  SearchHeader.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/08.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class SearchHeader: BaseTableViewHeader {
    let viewBackground = UIView().then {
        $0.backgroundColor = .systemBackground
    }
    let labelTitle = UILabel().then {
        $0.textColor = 0x323232.color
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }

    override func initialize() {
        setupViews()
    }

    private func setupViews() {
        addSubview(viewBackground)
        viewBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}
