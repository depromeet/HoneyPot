//
//  ItemViewController.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/13.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxKeyboard

class ItemViewController: BaseViewController, View {
    private enum Color {
        static let navigationBackground = 0xFFD136.color
        static let mainTitle = 0x323232.color
        static let priceFocusedTitle = 0xEB5757.color
        static let likeCommentTitle = 0x7B7B7B.color
    }
    private enum Font {
        static let mainTitle = UIFont.systemFont(ofSize: 24, weight: .bold)
        static let likeCommentTitle = UIFont(name: "AppleSDGothicNeo-Bold", size: 12)
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

    let viewBackground = UIView().then {
        $0.backgroundColor = Color.navigationBackground
    }

    lazy var navigationBar = NavigationBar(
        leftView: buttonBack
    ).then {
        $0.backgroundColor = .clear
    }
    let buttonBack = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_back_w24h24"), for: .normal)
    }
    let labelName = UILabel().then {
        $0.textColor = Color.mainTitle
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        $0.text = "테이블팬 C820 (3 Colors)"
    }

    let tableView = UITableView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.backgroundColor = .systemBackground
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .interactive
    }

    let viewHeader = UIView().then {
        $0.backgroundColor = .clear
    }
    let imageViewItem = UIImageView().then {
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    let buttonCategory = UIButton().then {
        $0.isUserInteractionEnabled = false
        $0.setTitle("가전", for: .normal)
        $0.setTitleColor(0x464646.color, for: .normal)
        $0.backgroundColor = UIColor.white.withAlphaComponent(80)
        $0.contentEdgeInsets = .init(top: 5, left: 10, bottom: 3, right: 10)
        $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }

    let labelTitle = UILabel().then {
        $0.textColor = Color.mainTitle
        $0.font = UIFont(name: "GodoB", size: 24)
        $0.text = "테이블팬 C820 (3 Colors)"
        $0.numberOfLines = 0
    }
    let labelPriceOriginal = UILabel().then {
        let attributedText = NSAttributedString(string: "50,000", attributes: [
                .font: Font.priceSmallTitle,
                .foregroundColor: 0xA5A5A5.color,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ])
        $0.attributedText = attributedText
    }
    let labelPriceDiscount = UILabel().then {
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

    let buttonDiscountUntil = UIButton().then {
        $0.isUserInteractionEnabled = false
        $0.setImage(#imageLiteral(resourceName: "icon_logo_w24h21"), for: .normal)
        $0.setTitle("40% 할인까지 24명!", for: .normal)
        $0.setTitleColor(Color.mainTitle, for: .normal)
        $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        $0.titleEdgeInsets = .init(top: 1, left: 5, bottom: 0, right: -5)
    }
    let buttonDiscountInfo = UIButton().then {
        $0.setTitle("할인안내", for: .normal)
        $0.setTitleColor(0x464646.color, for: .normal)
        $0.backgroundColor = 0xF8F8F8.color
        $0.contentEdgeInsets = .init(top: 5, left: 10, bottom: 3, right: 10)
        $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
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

    let imageViewDetail = UIImageView().then {
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    var constraintDetailHeight: NSLayoutConstraint!

    let viewInput = UIView().then {
        $0.backgroundColor = .clear
    }
    let buttonComment = UIButton().then {
        $0.setTitle("56개", for: .normal)
        $0.setTitleColor(0xA5A5A5.color, for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icon_bubble_w24h24"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        $0.titleEdgeInsets = .init(top: 1, left: 2, bottom: 0, right: -2)
        $0.adjustsImageWhenHighlighted = false
    }
    let textViewInput = ResizableTextView().then {
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        $0.textColor = Color.mainTitle
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
    }
    let buttonSend = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_write_w16h16"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    let labelInputPlaceholder = UILabel().then {
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        $0.text = "댓글을 남겨주세요"
        $0.textColor = 0xA5A5A5.color
    }

    let viewBottom = UIView().then {
        $0.backgroundColor = .white
    }
    var constraintBottomView: NSLayoutConstraint!
    let buttonShare = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "image_share_w48h50"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    let buttonLike = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "image_favorite_w48h50"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    let buttonSubmit = UIButton().then {
        $0.setTitle("참여하기", for: .normal)
        $0.setBackgroundImage(#imageLiteral(resourceName: "image_submit"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.setContentHuggingPriority(.init(1), for: .horizontal)
        $0.adjustsImageWhenHighlighted = false
    }
    let buttonSharePopUp = UIButton().then {
        $0.setTitle("소문내고 더 할인받기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundImage(#imageLiteral(resourceName: "image_black_bubble"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        $0.contentEdgeInsets = .init(top: 7, left: 8, bottom: 12, right: 25)
    }

    init(reactor: ItemReactor) {
        super.init(provider: reactor.provider)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupConstraints() {
        setupNavigationBar()
        setupTableView()
        setupBottomView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let headerView = tableView.tableHeaderView {
            headerView.frame.size.height = viewHeader.bounds.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }

    func bind(reactor: ItemReactor) {
        buttonBack.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        buttonSharePopUp.rx.tap
            .map { true }
            .bind(to: buttonSharePopUp.rx.isHidden)
            .disposed(by: disposeBag)

        let isHidden = tableView.rx.contentOffset
            .map { $0.y < 150 }
            .distinctUntilChanged()

        isHidden
            .bind(to: viewBackground.rx.isHidden)
            .disposed(by: disposeBag)

        isHidden
            .bind(to: labelName.rx.isHidden)
            .disposed(by: disposeBag)

        textViewInput.rx.text
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard self.isViewLoaded else { return }
                self.view.setNeedsLayout()
            })
            .disposed(by: disposeBag)

        textViewInput.rx.text.orEmpty
            .map { !$0.isEmpty }
            .bind(to: labelInputPlaceholder.rx.isHidden)
            .disposed(by: disposeBag)

        Driver.combineLatest(
            RxKeyboard.instance.visibleHeight.skip(1),
            RxKeyboard.instance.visibleHeight
        )
            .filter { $0.0 != .zero && $0.1 == .zero }
            .drive(onNext: { [unowned self] height, _ in
                let next = self.view.bounds.height - height
                let current = self.tableView.convert(self.viewInput.frame, to: nil).maxY
                let offset = current - next
                let contentOffsetY = self.tableView.contentOffset.y
                self.tableView.contentOffset = .init(x: 0, y: contentOffsetY + offset)
            })
            .disposed(by: disposeBag)

        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] height in
                let constant = height - self.view.safeAreaInsets.bottom - self.viewBottom.bounds.height
                self.constraintBottomView?.constant = -max(constant, 0)
                self.view.layoutIfNeeded()
            }).disposed(by: disposeBag)
    }
}

extension ItemViewController {
    private func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(44)
        }
        navigationBar.addSubview(labelName)
        labelName.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(52)
            $0.trailing.equalToSuperview().inset(9)
            $0.centerY.equalToSuperview()
        }
        view.insertSubview(viewBackground, belowSubview: navigationBar)
        viewBackground.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationBar)
        }
    }
    private func setupTableView() {
        view.insertSubview(tableView, at: 0)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        let viewBanner = setupItemBanner()
        let viewInfo = setupItemInfo(view: viewBanner)
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
            $0.top.leading.trailing.equalToSuperview()
        }

        tableView.tableHeaderView = viewTableHeader
    }
    private func setupItemBanner() -> UIView {
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
        return viewBanner
    }
    private func setupItemInfo(view: UIView) -> UIView {
        let viewInfo = UIView().then {
            $0.backgroundColor = .clear
        }
        viewHeader.addSubview(viewInfo)
        viewInfo.snp.makeConstraints {
            $0.top.equalTo(imageViewItem.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        viewInfo.addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(18).priority(999)
        }
        let stackViewPrice = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.alignment = .leading
            $0.spacing = 1
        }
        viewInfo.addSubview(stackViewPrice)
        stackViewPrice.snp.makeConstraints {
            $0.top.equalTo(labelTitle.snp.bottom).offset(12)
            $0.leading.equalTo(labelTitle)
            $0.bottom.equalToSuperview().inset(21)
        }
        let viewPrice = UIView().then {
            $0.backgroundColor = .clear
        }
        viewPrice.addSubview(labelPriceDiscount)
        labelPriceDiscount.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        viewPrice.addSubview(labelCurrency)
        labelCurrency.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(labelPriceDiscount.snp.trailing)
        }
        stackViewPrice.addArrangedSubview(labelPriceOriginal)
        stackViewPrice.addArrangedSubview(viewPrice)
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
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(17)
        }
        viewDiscount.addSubview(buttonDiscountInfo)
        buttonDiscountInfo.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(18)
        }

        let viewProgressBackground = UIView().then {
            $0.backgroundColor = 0xEAEAEA.color
        }
        viewDiscount.addSubview(viewProgressBackground)
        viewProgressBackground.snp.makeConstraints {
            $0.top.equalTo(buttonDiscountUntil.snp.bottom).offset(15)
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
        let imageViewCount = UIImageView(image: #imageLiteral(resourceName: "icon_people_w18h18"))
        viewDeadline.addSubview(imageViewCount)
        imageViewCount.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.leading.equalToSuperview().inset(Metric.leadingOffset)
            $0.bottom.equalToSuperview().inset(2)
            $0.width.height.equalTo(18)
        }
        viewDeadline.addSubview(labelCount)
        labelCount.snp.makeConstraints {
            $0.leading.equalTo(imageViewCount.snp.trailing).offset(5)
            $0.centerY.equalTo(imageViewCount).offset(1)
        }
        let imageViewTime = UIImageView(image: #imageLiteral(resourceName: "icon_clock_w18h18"))
        viewDeadline.addSubview(imageViewTime)
        imageViewTime.snp.makeConstraints {
            $0.leading.equalTo(labelCount.snp.trailing).offset(8)
            $0.centerY.equalTo(imageViewCount)
            $0.width.height.equalTo(18)
        }
        viewDeadline.addSubview(labelTime)
        labelTime.snp.makeConstraints {
            $0.leading.equalTo(imageViewTime.snp.trailing).offset(5)
            $0.centerY.equalTo(imageViewTime).offset(1)
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
            $0.backgroundColor = 0xF8F8F8.color
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
        }
        viewProfile.addSubview(viewBackground)
        viewBackground.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(18).priority(999)
            $0.height.equalTo(66)
        }
        let imageViewThumbnail = UIImageView(image: #imageLiteral(resourceName: "image_thumbnail_w40h36"))
        viewBackground.addSubview(imageViewThumbnail)
        imageViewThumbnail.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(40)
        }
        let viewText = UIView().then {
            $0.backgroundColor = .clear
        }
        viewBackground.addSubview(viewText)
        viewText.snp.makeConstraints {
            $0.leading.equalTo(imageViewThumbnail.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        let labelTop = UILabel().then {
            $0.text = "디프만컴파니"
            $0.textColor = 0x464646.color
            $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        }
        viewText.addSubview(labelTop)
        labelTop.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        let labelBottom = UILabel().then {
            $0.text = "467개의 후기"
            $0.textColor = 0x464646.color
            $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        }
        viewText.addSubview(labelBottom)
        labelBottom.snp.makeConstraints {
            $0.top.equalTo(labelTop.snp.bottom)
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
            $0.top.equalToSuperview().inset(23)
            $0.leading.equalToSuperview().inset(18)
        }
        let viewBackground = UIView().then {
            $0.backgroundColor = 0xF8F8F8.color
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
            $0.top.bottom.equalToSuperview().inset(0)
            $0.leading.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(32).priority(999)
        }
        viewBackground.addSubview(buttonSend)
        buttonSend.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalTo(32)
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
    }
    private func setupBottomView() {
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
            $0.backgroundColor = 0xA5A5A5.color
        }
        viewBottom.addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        view.addSubview(buttonSharePopUp)
        buttonSharePopUp.snp.makeConstraints {
            $0.leading.equalTo(buttonShare)
            $0.bottom.equalTo(buttonShare.snp.top).offset(-4)
        }
    }
}
