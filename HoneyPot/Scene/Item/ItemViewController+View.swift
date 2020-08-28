//
//  ItemViewController+View.swift
//  HoneyPot
//
//  Created by Soso on 2020/08/28.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

extension ItemViewController {
    private enum Color {
        static let lightGray2 = 0xF8F8F8.color
    }

    private enum Metric {
        static let leadingOffset: CGFloat = 18
        static let trailingOffset: CGFloat = 18
    }

    func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(44)
        }
        view.insertSubview(viewBackground, belowSubview: navigationBar)
        viewBackground.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationBar)
        }
    }

    func setupTableView() {
        view.insertSubview(tableView, at: 0)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        setupItemBanner()
        let viewInfo = setupItemInfo()
        let viewDiscount = setupItemDiscount(view: viewInfo)
        let viewDeadline = setupItemDeadline(view: viewDiscount)
        let viewProfile = setupItemProfile(view: viewDeadline)
        setupItemDetail(view: viewProfile)
        setupInput()

        let viewTableHeader = UIView().then {
            $0.backgroundColor = .clear
        }
        viewTableHeader.addSubview(viewHeader)
        viewHeader.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        tableView.tableHeaderView = viewTableHeader
    }

    private func setupItemBanner() {
        let viewBanner = UIView().then {
            $0.backgroundColor = .clear
        }
        viewHeader.addSubview(viewBanner)
        viewBanner.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(viewBanner.snp.width)
        }
        viewBanner.addSubview(imageViewItem)
        imageViewItem.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }

        viewBanner.addSubview(buttonCategory)
        buttonCategory.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(15)
        }
    }

    private func setupItemInfo() -> UIView {
        let viewInfo = UIView().then {
            $0.backgroundColor = .clear
        }
        viewHeader.addSubview(viewInfo)
        viewInfo.snp.makeConstraints {
            $0.top.equalTo(imageViewItem.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        viewInfo.addSubview(labelItem)
        labelItem.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(18).priority(999)
        }
        let stackViewPrice = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.alignment = .leading
            $0.spacing = 3
        }
        viewInfo.addSubview(stackViewPrice)
        stackViewPrice.snp.makeConstraints {
            $0.top.equalTo(labelItem.snp.bottom).offset(8)
            $0.leading.equalTo(labelItem)
            $0.bottom.equalToSuperview().inset(16)
        }
        let stackViewDiscount = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
            $0.alignment = .leading
            $0.spacing = 11
        }
        stackViewDiscount.addArrangedSubview(labelPricePercent)
        stackViewDiscount.addArrangedSubview(labelPriceDiscount)
        viewInfo.addSubview(labelCurrency)
        labelCurrency.snp.makeConstraints {
            $0.leading.equalTo(stackViewPrice.snp.trailing).offset(2)
            $0.bottom.equalTo(stackViewPrice).inset(6)
        }
        stackViewPrice.addArrangedSubview(labelPriceOriginal)
        stackViewPrice.addArrangedSubview(stackViewDiscount)
        let viewSeparator = UIView().then {
            $0.backgroundColor = 0xEEEEEE.color
        }
        viewInfo.addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20).priority(999)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        return viewInfo
    }

    private func setupItemDiscount(view: UIView) -> UIView {
        let viewDiscount = UIView().then {
            $0.backgroundColor = .clear
        }
        viewHeader.addSubview(viewDiscount)
        viewDiscount.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        viewDiscount.addSubview(buttonDiscountUntil)
        buttonDiscountUntil.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19)
            $0.leading.equalToSuperview().inset(17)
        }
        viewDiscount.addSubview(buttonDiscountInfo)
        buttonDiscountInfo.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17)
            $0.trailing.equalToSuperview().inset(18)
        }
        viewDiscount.addSubview(viewProgressBackground)
        viewProgressBackground.snp.makeConstraints {
            $0.top.equalTo(buttonDiscountUntil.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(Metric.leadingOffset).priority(999)
            $0.height.equalTo(4)
            $0.bottom.equalToSuperview()
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
        return viewDiscount
    }

    private func setupItemDeadline(view: UIView) -> UIView {
        let viewDeadline = UIView().then {
            $0.backgroundColor = .clear
        }
        viewHeader.addSubview(viewDeadline)
        viewDeadline.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        viewDeadline.addSubview(buttonCount)
        buttonCount.snp.makeConstraints {
            $0.top.equalToSuperview().inset(11)
            $0.leading.equalToSuperview().inset(Metric.leadingOffset)
            $0.bottom.equalToSuperview()
        }
        viewDeadline.addSubview(buttonTime)
        buttonTime.snp.makeConstraints {
            $0.leading.equalTo(buttonCount.snp.trailing).offset(8)
            $0.top.bottom.equalTo(buttonCount)
        }

        return viewDeadline
    }

    private func setupItemProfile(view: UIView) -> UIView {
        let viewProfile = UIView().then {
            $0.backgroundColor = .clear
        }
        viewHeader.addSubview(viewProfile)
        viewProfile.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        let viewBackground = UIView().then {
            $0.backgroundColor = Color.lightGray2
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
        }
        viewProfile.addSubview(viewBackground)
        viewBackground.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(18).priority(999)
            $0.height.equalTo(66)
        }
        viewBackground.addSubview(imageViewThumbnail)
        imageViewThumbnail.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        let viewText = UIView().then {
            $0.backgroundColor = .clear
        }
        viewBackground.addSubview(viewText)
        viewText.snp.makeConstraints {
            $0.leading.equalTo(imageViewThumbnail.snp.trailing).offset(8)
            $0.centerY.equalToSuperview().offset(1)
        }
        viewText.addSubview(labelSeller)
        labelSeller.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        viewText.addSubview(labelReview)
        labelReview.snp.makeConstraints {
            $0.top.equalTo(labelSeller.snp.bottom).offset(2)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        let buttonEdit = UIButton().then {
            $0.setImage(#imageLiteral(resourceName: "icon_indicator_w24h24"), for: .normal)
        }
        viewBackground.addSubview(buttonEdit)
        buttonEdit.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(viewText.snp.trailing)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(44)
        }
        return viewProfile
    }

    private func setupItemDetail(view: UIView) {
        viewHeader.addSubview(imageViewDetail)
        imageViewDetail.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        constraintDetailHeight = imageViewDetail.heightAnchor.constraint(equalToConstant: 300)
        constraintDetailHeight.isActive = true
    }

    private func setupInput() {
        viewHeader.addSubview(viewInput)
        viewInput.snp.makeConstraints {
            $0.top.equalTo(imageViewDetail.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        viewInput.addSubview(buttonComment)
        buttonComment.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(18)
        }
        viewInput.addSubview(buttonViewAll)
        buttonViewAll.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalTo(buttonComment)
        }
        let viewBackground = UIView().then {
            $0.backgroundColor = Color.lightGray2
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        viewInput.addSubview(viewBackground)
        viewBackground.snp.makeConstraints {
            $0.top.equalTo(buttonComment.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview().inset(18).priority(999)
            $0.bottom.equalToSuperview().inset(25)
        }
        viewBackground.addSubview(textViewInput)
        textViewInput.snp.makeConstraints {
            $0.top.equalToSuperview().inset(1)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(32).priority(999)
        }
        viewBackground.addSubview(buttonSend)
        buttonSend.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        viewBackground.addSubview(labelInputPlaceholder)
        labelInputPlaceholder.snp.makeConstraints {
            $0.leading.equalTo(textViewInput).inset(5)
            $0.centerY.equalTo(textViewInput)
        }
        let viewSeparator = UIView().then {
            $0.backgroundColor = 0xEEEEEE.color
        }
        viewInput.addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        viewInput.addSubview(buttonRedirect)
        buttonRedirect.snp.makeConstraints {
            $0.edges.equalTo(viewBackground)
        }
    }

    func setupBottomView() {
        view.addSubview(viewBottom)
        viewBottom.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(80)
        }
        constraintBottomView = viewBottom.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        constraintBottomView.isActive = true
        viewBottom.addSubview(buttonShare)
        buttonShare.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(Metric.leadingOffset)
        }
        viewBottom.addSubview(buttonLike)
        buttonLike.snp.makeConstraints {
            $0.leading.equalTo(buttonShare.snp.trailing).offset(10)
            $0.centerY.equalTo(buttonShare)
        }
        viewBottom.addSubview(buttonSubmit)
        buttonSubmit.snp.makeConstraints {
            $0.leading.equalTo(buttonLike.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(Metric.trailingOffset)
            $0.centerY.equalTo(buttonLike)
        }
        let viewSeparator = UIView().then {
            $0.backgroundColor = 0xCACACA.color
        }
        viewBottom.addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-1)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        view.addSubview(buttonSharePopUp)
        buttonSharePopUp.snp.makeConstraints {
            $0.leading.equalTo(buttonShare)
            $0.bottom.equalTo(buttonShare.snp.top).offset(-2)
        }
        view.addSubview(buttonScrollToTop)
        buttonScrollToTop.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(viewBottom.snp.top).offset(-20)
        }
    }
}
