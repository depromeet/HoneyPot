//
//  ItemCell.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/09.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import SnapKit
import Then

class ItemCell: BaseTableViewCell {
    private enum Color {
        static let likeCommentTitle = 0x7B7B7B.color
        static let mainTitle = 0x323232.color
        static let categoryTitle = 0x464646.color
        static let priceFocusedTitle = 0xEB5757.color
        static let countTitle = 0x8C8C8C.color
    }
    private enum Font {
        static let godoB20 = UIFont(name: "GodoB", size: 20)!
        static let sdR16 = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)!
        static let sdB24 = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)!
        static let sdB14 = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)!
        static let sdB12 = UIFont(name: "AppleSDGothicNeo-Bold", size: 12)!
        static let sdR14 = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
        static let sdR12 = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)!
    }
    private enum Metric {
        static let leadingOffset: CGFloat = 18
        static let trailingOffset: CGFloat = 18
    }
    private enum Style {
        static let paragraph = NSMutableParagraphStyle().then {
            $0.lineSpacing = 4
        }
        static let itemText: [NSAttributedString.Key: Any] = [
            .kern: -0.6,
            .font: Font.godoB20,
            .foregroundColor: Color.mainTitle,
            .paragraphStyle: paragraph
        ]
        static let countNormalText: [NSAttributedString.Key: Any] = [
            .kern: -0.3,
            .font: Font.sdR14,
            .foregroundColor: Color.countTitle
        ]
        static let countFocusText: [NSAttributedString.Key: Any] = [
            .kern: -0.3,
            .font: Font.sdB14,
            .foregroundColor: Color.countTitle
        ]
    }

    let viewContainer = UIView().then {
        $0.backgroundColor = .clear
    }

    let imageViewItem = UIImageView().then {
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }

    let buttonLike = UIButton().then {
        $0.isUserInteractionEnabled = false
        $0.setImage(#imageLiteral(resourceName: "icon_heart_w16h16"), for: .normal)
        $0.setTitle("302", for: .normal)
        $0.setTitleColor(Color.likeCommentTitle, for: .normal)
        $0.titleLabel?.font = Font.sdB12
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 9)
        $0.titleEdgeInsets = .init(top: 0, left: 3, bottom: 0, right: -3)
    }
    let buttonComment = UIButton().then {
        $0.isUserInteractionEnabled = false
        $0.setImage(#imageLiteral(resourceName: "icon_bubble_w16h16"), for: .normal)
        $0.setTitle("13", for: .normal)
        $0.setTitleColor(Color.likeCommentTitle, for: .normal)
        $0.titleLabel?.font = Font.sdB12
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 9)
        $0.titleEdgeInsets = .init(top: 0, left: 3, bottom: 0, right: -3)
    }

    let labelTitle = UILabel().then {
        let attributedString = NSAttributedString(string: "테이블팬 C820 (3 Colors)", attributes: Style.itemText)
        $0.attributedText = attributedString
        $0.numberOfLines = 2
    }
    let labelCategory = UILabel().then {
        $0.textColor = Color.categoryTitle
        $0.font = Font.sdR16
        $0.text = "가전  I  플러스마이너스제로"
    }
    var constraintProgressTrailing: NSLayoutConstraint!

    let buttonCount = UIButton().then {
        let first = NSAttributedString(string: "426명", attributes: Style.countFocusText)
        let second = NSAttributedString(string: " 참여중", attributes: Style.countNormalText)
        let attributedText = NSMutableAttributedString()
        attributedText.append(first)
        attributedText.append(second)
        $0.setAttributedTitle(attributedText, for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icon_people_w18h18"), for: .normal)
        $0.titleEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: -5)
        $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
        $0.isUserInteractionEnabled = false
    }
    let buttonTime = UIButton().then {
        let first = NSAttributedString(string: "4일 21시간", attributes: Style.countFocusText)
        let second = NSAttributedString(string: " 남음", attributes: Style.countNormalText)
        let attributedText = NSMutableAttributedString()
        attributedText.append(first)
        attributedText.append(second)
        $0.setAttributedTitle(attributedText, for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icon_clock_w18h18"), for: .normal)
        $0.titleEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: -5)
        $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
        $0.isUserInteractionEnabled = false
    }
    let labelPricePercent = UILabel().then {
        $0.font = Font.sdB24
        $0.textColor = Color.priceFocusedTitle
        $0.text = "35%"
    }
    let labelPriceDiscount = UILabel().then {
        $0.font = Font.sdB24
        $0.textColor = Color.mainTitle
        $0.text = "32,500"
    }
    let labelCurrency = UILabel().then {
        $0.font = Font.sdR14
        $0.textColor = Color.mainTitle
        $0.text = "원"
    }
    let labelOverview = UILabel().then {
        $0.textColor = Color.likeCommentTitle
        $0.font = Font.sdR12
        $0.text = "40% 할인까지 24명!"
    }

    override func initialize() {
        setupViews()
    }

    private func setupViews() {
        selectionStyle = .none
        addSubview(viewContainer)
        viewContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        setupImageView()
        setupItem()
        setupProgress()
        setupInfo()
    }

    private func setupImageView() {
        viewContainer.addSubview(imageViewItem)
        imageViewItem.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(Metric.leadingOffset)
            $0.height.equalTo(imageViewItem.snp.width).multipliedBy(10.5 / 16.0)
        }
        let stackViewButton = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
            $0.alignment = .fill
            $0.spacing = 5
        }
        stackViewButton.addArrangedSubview(buttonLike)
        stackViewButton.addArrangedSubview(buttonComment)
        viewContainer.addSubview(stackViewButton)
        stackViewButton.snp.makeConstraints {
            $0.top.trailing.equalTo(imageViewItem).inset(15)
        }
    }
    private func setupItem() {
        viewContainer.addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.top.equalTo(imageViewItem.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview().inset(Metric.leadingOffset)
        }
        viewContainer.addSubview(labelCategory)
        labelCategory.snp.makeConstraints {
            $0.top.equalTo(labelTitle.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview().inset(Metric.leadingOffset)
        }
    }
    private func setupProgress() {
        let viewProgressBackground = UIView().then {
            $0.backgroundColor = 0xEAEAEA.color
        }
        viewContainer.addSubview(viewProgressBackground)
        viewProgressBackground.snp.makeConstraints {
            $0.top.equalTo(labelCategory.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(Metric.leadingOffset)
            $0.height.equalTo(4)
        }
        let viewProgress = UIView().then {
            $0.backgroundColor = 0xFFC500.color
        }
        viewProgressBackground.addSubview(viewProgress)
        viewProgress.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        constraintProgressTrailing = viewProgressBackground.trailingAnchor.constraint(equalTo: viewProgress.trailingAnchor, constant: 100)
        constraintProgressTrailing.isActive = true
    }
    private func setupInfo() {
        viewContainer.addSubview(buttonCount)
        buttonCount.snp.makeConstraints {
            $0.top.equalTo(labelCategory.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(Metric.leadingOffset)
            $0.height.equalTo(18)
        }
        viewContainer.addSubview(buttonTime)
        buttonTime.snp.makeConstraints {
            $0.top.equalTo(buttonCount.snp.bottom).offset(4)
            $0.leading.equalTo(buttonCount)
            $0.height.equalTo(18)
            $0.bottom.equalToSuperview().inset(18)
        }
        viewContainer.addSubview(labelCurrency)
        labelCurrency.snp.makeConstraints {
            $0.top.equalTo(labelCategory.snp.bottom).offset(29)
            $0.trailing.equalToSuperview().inset(Metric.trailingOffset)
        }
        viewContainer.addSubview(labelPriceDiscount)
        labelPriceDiscount.snp.makeConstraints {
            $0.trailing.equalTo(labelCurrency.snp.leading).offset(-3)
            $0.bottom.equalTo(labelCurrency).inset(-5)
        }
        viewContainer.addSubview(labelPricePercent)
        labelPricePercent.snp.makeConstraints {
            $0.trailing.equalTo(labelPriceDiscount.snp.leading).offset(-7)
            $0.centerY.equalTo(labelPriceDiscount)
        }
        viewContainer.addSubview(labelOverview)
        labelOverview.snp.makeConstraints {
            $0.top.equalTo(labelCurrency.snp.bottom).offset(5)
            $0.trailing.equalTo(labelCurrency)
        }
    }
}
