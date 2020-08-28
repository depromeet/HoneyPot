//
//  NavigationBar.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/03.
//  Copyright © 2020 Soso. All rights reserved.
//

import SnapKit
import Then
import UIKit

class NavigationBar: UIView {
    init(
        title: String? = nil,
        leftView: UIView? = nil,
        rightViews: [UIView] = []
    ) {
        super.init(frame: .zero)
        setupViews(title: title, leftView: leftView, rightViews: rightViews)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let imageViewLogo = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "image_logo_w79h24")
        $0.contentMode = .scaleAspectFit
    }

    let labelTitle = UILabel().then {
        $0.textColor = 0x323232.color
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        $0.textAlignment = .center
    }

    let stackViewRight = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }

    func setupViews(
        title: String?,
        leftView: UIView?,
        rightViews: [UIView]
    ) {
        if let left = leftView {
            addSubview(left)
            left.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(4)
                $0.leading.equalToSuperview().inset(12)
                $0.width.equalTo(left.snp.height)
            }
        } else {
            addSubview(imageViewLogo)
            imageViewLogo.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(18)
                $0.centerY.equalToSuperview()
            }
        }
        if !rightViews.isEmpty {
            addSubview(stackViewRight)
            stackViewRight.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(4)
                $0.trailing.equalToSuperview().inset(12)
            }
            for rightView in rightViews {
                stackViewRight.addArrangedSubview(rightView)
                rightView.snp.makeConstraints {
                    $0.width.equalTo(rightView.snp.height)
                }
            }
        }
        labelTitle.text = title
        addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(49)
            $0.centerY.equalToSuperview()
        }
    }
}
