//
//  ItemSubCommentCell.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/15.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import SnapKit
import Then

class ItemSubCommentCell: BaseTableViewCell {
    private enum Color {
        static let mainText = 0x323232.color
        static let subText = 0xA5A5A5.color
    }
    private enum Font {
        static let usernameText = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)!
        static let contentText = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
        static let extraText = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)!
    }
    private enum Style {
        static let paragraph = NSMutableParagraphStyle().then {
            $0.lineSpacing = 3
        }
        static let contentText: [NSAttributedString.Key: Any] = [
            .kern: -0.4,
            .font: Font.contentText,
            .foregroundColor: Color.mainText,
            .paragraphStyle: paragraph
        ]
    }

    let viewContainer = UIView().then {
        $0.backgroundColor = .clear
    }

    let labelUsername = UILabel().then {
        $0.text = "노은종"
        $0.textColor = Color.mainText
        $0.font = Font.usernameText
    }
    let labelTime = UILabel().then {
        $0.text = "10분 전"
        $0.textColor = Color.subText
        $0.font = Font.extraText
    }
    let buttonMore = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_more_w24h24"), for: .normal)
    }

    let labelContent = UILabel().then {
        let attributedString = NSAttributedString(string: "선풍기는 시원하고 시원한건 아이스크림 아이스크림 메로나", attributes: Style.contentText)
        $0.attributedText = attributedString
        $0.numberOfLines = 0
    }

    let buttonLike = UIButton().then {
        $0.setTitle("1", for: .normal)
        $0.setTitleColor(Color.subText, for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icon_like_normal_w16h16"), for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icon_like_selected_w16h16"), for: .selected)
        $0.titleLabel?.font = Font.extraText
        $0.titleEdgeInsets = .init(top: 1, left: 3, bottom: 0, right: -3)
        $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 3)
        $0.adjustsImageWhenHighlighted = false
    }

    override func initialize() {
        setupViews()
    }

    private func setupViews() {
        selectionStyle = .none
        addSubview(viewContainer)
        viewContainer.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(44)
        }
        let viewSeparator = UIView().then {
            $0.backgroundColor = 0xEEEEEE.color
        }
        addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.top.equalTo(viewContainer.snp.bottom).offset(18)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }

        setupInfo()
        setupContent()
        setupAction()
    }

    func setContentText(text: String) {
        let attributedString = NSAttributedString(string: text, attributes: Style.contentText)
        labelContent.attributedText = attributedString
    }
}

extension ItemSubCommentCell {
    private func setupInfo() {
        viewContainer.addSubview(labelUsername)
        labelUsername.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.leading.equalToSuperview()
        }
        viewContainer.addSubview(labelTime)
        labelTime.snp.makeConstraints {
            $0.leading.equalTo(labelUsername.snp.trailing).offset(8)
            $0.centerY.equalTo(labelUsername).offset(1)
        }
        viewContainer.addSubview(buttonMore)
        buttonMore.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(labelTime.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(labelUsername)
        }
    }
    private func setupContent() {
        viewContainer.addSubview(labelContent)
        labelContent.snp.makeConstraints {
            $0.top.equalTo(labelUsername.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview()
        }
    }
    private func setupAction() {
        viewContainer.addSubview(buttonLike)
        buttonLike.snp.makeConstraints {
            $0.top.equalTo(labelContent.snp.bottom).offset(7)
            $0.leading.bottom.equalToSuperview()
            $0.height.equalTo(16)
        }
    }
}
