//
//  MyPageViewController.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/07/28.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SwiftyColor
import SnapKit
import Then

class MyPageViewController: BaseViewController, View {
    private enum Color {
        static let navigationBackground = 0xFFD136.color
        static let navigationTitle = 0x323232.color
        static let profileTitle = 0x323232.color
        static let buttonTitle = 0x323232.color
        static let separatorBackground = 0xECECEC.color
    }
    private enum Font {
        static let buttonTitle = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
    }

    lazy var navigationBar = NavigationBar(
        leftView: buttonBack,
        rightViews: [buttonAlert]
    ).then {
        $0.backgroundColor = .clear
    }
    let labelTitle = UILabel().then {
        $0.textColor = Color.navigationTitle
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        $0.text = "마이 페이지"
    }

    let tableView = UITableView().then {
        $0.register(MenuCell.self, forCellReuseIdentifier: "cell")
        $0.rowHeight = 57
        $0.separatorInset = .zero
        $0.separatorColor = Color.separatorBackground
        $0.tableFooterView = UIView(frame: .zero)
    }

    let viewContainer = UIView().then {
        $0.backgroundColor = .systemBackground
    }

    let buttonBack = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_back_w24h24"), for: .normal)
    }
    let buttonAlert = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_alert_w24h24"), for: .normal)
    }

    let viewProfile = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = 0xF8F8F8.color
    }
    let labelUsername = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.text = "노은종"
        $0.textColor = Color.profileTitle
    }
    let labelUserType = UILabel().then {
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        $0.text = "개인회원"
        $0.textColor = Color.profileTitle
    }
    let buttonEdit = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_indicator_w24h24"), for: .normal)
    }

    let buttonPay = VerticalButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_card_w60h60"), for: .normal)
        $0.setTitle("결제정보", for: .normal)
        $0.setTitleColor(Color.buttonTitle, for: .normal)
        $0.imageView?.contentMode = .center
        $0.titleLabel?.font = Font.buttonTitle
        $0.titleLabel?.textAlignment = .center
    }
    let buttonPurchase = VerticalButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_cart_w60h60"), for: .normal)
        $0.setTitle("구매내역", for: .normal)
        $0.setTitleColor(Color.buttonTitle, for: .normal)
        $0.imageView?.contentMode = .center
        $0.titleLabel?.font = Font.buttonTitle
        $0.titleLabel?.textAlignment = .center
    }
    let buttonLike = VerticalButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_heart_w60h60"), for: .normal)
        $0.setTitle("관심정보", for: .normal)
        $0.setTitleColor(Color.buttonTitle, for: .normal)
        $0.imageView?.contentMode = .center
        $0.titleLabel?.font = Font.buttonTitle
        $0.titleLabel?.textAlignment = .center
    }

    init(reactor: MyPageReactor) {
        super.init(provider: reactor.provider)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupConstraints() {
        setupNavigationBar()
        setupTableView()
        setupProfile()
        setupInfo()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let header = tableView.tableHeaderView {
            header.frame.size.height = 216
        }
    }

    func bind(reactor: MyPageReactor) {
        buttonBack.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Menu.self)
            .filter { $0 == .setting }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let setting = SettingViewController(reactor: .init(provider: self.provider))
                self.navigationController?.pushViewController(setting, animated: true)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.name }
            .bind(to: labelUsername.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.menus }
            .distinctUntilChanged()
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: MenuCell.self)) { _, menu, cell in
                cell.imageViewIcon.image = menu.image
                cell.labelTitle.text = menu.title
            }.disposed(by: disposeBag)
    }
}

extension MyPageViewController {
    private func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(44)
        }
        let viewBackground = UIView().then {
            $0.backgroundColor = Color.navigationBackground
        }
        view.insertSubview(viewBackground, belowSubview: navigationBar)
        viewBackground.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationBar)
        }
        navigationBar.addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    private func setupProfile() {
        viewContainer.addSubview(viewProfile)
        viewProfile.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalTo(viewContainer.safeAreaLayoutGuide).inset(15).priority(999)
            $0.height.equalTo(48)
        }
        viewProfile.addSubview(buttonEdit)
        buttonEdit.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(44).priority(999)
        }
        viewProfile.addSubview(labelUsername)
        labelUsername.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16).priority(999)
        }
        viewProfile.addSubview(labelUserType)
        labelUserType.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(labelUsername.snp.trailing).offset(8)
        }
    }
    private func setupInfo() {
        let stackViewButtons = UIStackView(
            arrangedSubviews: [buttonPay, buttonPurchase, buttonLike]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
        viewContainer.addSubview(stackViewButtons)
        stackViewButtons.snp.makeConstraints {
            $0.top.equalTo(viewProfile.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(15).priority(999)
            $0.height.equalTo(100)
        }
        let viewSeparator = UIView().then {
            $0.backgroundColor = 0xF8F9FA.color
        }
        viewContainer.addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(viewContainer.safeAreaLayoutGuide)
            $0.height.equalTo(8)
        }
        tableView.tableHeaderView = viewContainer
    }
}
