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
    }
    private enum Font {
        static let likeCommentTitle = UIFont(name: "AppleSDGothicNeo-Bold", size: 12)
        static let mainTitle = UIFont.systemFont(ofSize: 20, weight: .bold)
        static let categoryTitle = UIFont.systemFont(ofSize: 14)
        static let focusedTitle = UIFont(name: "AppleSDGothicNeo-Bold", size: 12)!
        static let normalTitle = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)!
        static let priceBigTitle = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)!
        static let priceSmallTitle = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
    }
    private enum Metric {
        static let leadingOffset: CGFloat = 18
        static let trailingOffset: CGFloat = 18
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
        $0.titleLabel?.font = Font.likeCommentTitle
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.contentEdgeInsets = .init(top: 5, left: 6, bottom: 5, right: 9)
        $0.titleEdgeInsets = .init(top: 0, left: 3, bottom: 0, right: -3)
    }
    let buttonComment = UIButton().then {
        $0.isUserInteractionEnabled = false
        $0.setImage(#imageLiteral(resourceName: "icon_bubble_w16h16"), for: .normal)
        $0.setTitle("13", for: .normal)
        $0.setTitleColor(Color.likeCommentTitle, for: .normal)
        $0.titleLabel?.font = Font.likeCommentTitle
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.contentEdgeInsets = .init(top: 5, left: 6, bottom: 5, right: 9)
        $0.titleEdgeInsets = .init(top: 0, left: 3, bottom: 0, right: -3)
    }

    let labelTitle = UILabel().then {
        $0.textColor = Color.mainTitle
        $0.font = Font.mainTitle
        $0.text = "테이블팬 C820 (3 Colors)"
    }
    let labelCategory = UILabel().then {
        $0.textColor = Color.categoryTitle
        $0.font = Font.categoryTitle
        $0.text = "가전 | 디프만컴파니"
    }
    var constraintProgressTrailing: NSLayoutConstraint!

    let labelCount = UILabel().then {
        let first = NSAttributedString(string: "426명 ", attributes: [
                .font: Font.focusedTitle,
                .foregroundColor: Color.likeCommentTitle
            ])
        let second = NSAttributedString(string: "참여중", attributes: [
                .font: Font.normalTitle,
                .foregroundColor: Color.likeCommentTitle
            ])
        let attributedText = NSMutableAttributedString()
        attributedText.append(first)
        attributedText.append(second)
        $0.attributedText = attributedText
    }
    let labelTime = UILabel().then {
        let first = NSAttributedString(string: "4일 21시간 ", attributes: [
                .font: Font.focusedTitle,
                .foregroundColor: Color.likeCommentTitle
            ])
        let second = NSAttributedString(string: "남음", attributes: [
                .font: Font.normalTitle,
                .foregroundColor: Color.likeCommentTitle
            ])
        let attributedText = NSMutableAttributedString()
        attributedText.append(first)
        attributedText.append(second)
        $0.attributedText = attributedText
    }
    let labelPrice = UILabel().then {
        let first = NSAttributedString(string: "35% ", attributes: [
                .font: Font.priceBigTitle,
                .foregroundColor: Color.priceFocusedTitle
            ])
        let second = NSAttributedString(string: "32,500", attributes: [
                .font: Font.priceBigTitle,
                .foregroundColor: Color.mainTitle
            ])
        let attributedText = NSMutableAttributedString()
        attributedText.append(first)
        attributedText.append(second)
        $0.attributedText = attributedText
    }
    let labelCurrency = UILabel().then {
        let attributedText = NSAttributedString(string: " 원", attributes: [
                .font: Font.priceSmallTitle,
                .foregroundColor: Color.mainTitle
            ])
        $0.attributedText = attributedText
    }
    let labelOverview = UILabel().then {
        $0.textColor = Color.likeCommentTitle
        $0.font = Font.normalTitle
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
        viewContainer.addSubview(buttonComment)
        buttonComment.snp.makeConstraints {
            $0.top.trailing.equalTo(imageViewItem).inset(15)
        }
        viewContainer.addSubview(buttonLike)
        buttonLike.snp.makeConstraints {
            $0.top.equalTo(imageViewItem).inset(15)
            $0.trailing.equalTo(buttonComment.snp.leading).offset(-5)
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
            $0.top.equalTo(labelTitle.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(Metric.leadingOffset)
        }
    }
    private func setupProgress() {
        let viewProgressBackground = UIView().then {
            $0.backgroundColor = 0xEAEAEA.color
        }
        viewContainer.addSubview(viewProgressBackground)
        viewProgressBackground.snp.makeConstraints {
            $0.top.equalTo(labelCategory.snp.bottom).offset(13)
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
        let imageViewCount = UIImageView(image: #imageLiteral(resourceName: "icon_people_w18h18"))
        viewContainer.addSubview(imageViewCount)
        imageViewCount.snp.makeConstraints {
            $0.top.equalTo(labelCategory.snp.bottom).offset(27)
            $0.leading.equalToSuperview().inset(Metric.leadingOffset)
            $0.width.height.equalTo(18)
        }
        viewContainer.addSubview(labelCount)
        labelCount.snp.makeConstraints {
            $0.leading.equalTo(imageViewCount.snp.trailing).offset(5)
            $0.centerY.equalTo(imageViewCount)
        }
        let imageViewTime = UIImageView(image: #imageLiteral(resourceName: "icon_clock_w18h18"))
        viewContainer.addSubview(imageViewTime)
        imageViewTime.snp.makeConstraints {
            $0.top.equalTo(imageViewCount.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(Metric.leadingOffset)
            $0.width.height.equalTo(18)
            $0.bottom.equalToSuperview().inset(20)
        }
        viewContainer.addSubview(labelTime)
        labelTime.snp.makeConstraints {
            $0.leading.equalTo(imageViewTime.snp.trailing).offset(5)
            $0.centerY.equalTo(imageViewTime)
        }
        viewContainer.addSubview(labelCurrency)
        labelCurrency.snp.makeConstraints {
            $0.top.equalTo(imageViewItem.snp.bottom).offset(100)
            $0.trailing.equalToSuperview().inset(Metric.trailingOffset)
        }
        viewContainer.addSubview(labelPrice)
        labelPrice.snp.makeConstraints {
            $0.trailing.equalTo(labelCurrency.snp.leading)
            $0.bottom.equalTo(labelCurrency).inset(-5)
        }
        viewContainer.addSubview(labelOverview)
        labelOverview.snp.makeConstraints {
            $0.top.equalTo(labelCurrency.snp.bottom).offset(7)
            $0.trailing.equalTo(labelCurrency)
        }
    }
}
