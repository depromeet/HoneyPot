//
//  MyPageViewController.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/07/28.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyColor
import SnapKit
import Then

class MyPageViewController: BaseViewController {
    private enum Color {
        static let navigationBackground = 0xFFD136.color
        static let buttonTitle = 0x323232.color
        static let separatorBackground = 0xECECEC.color
    }

    private enum Menu {
        case invite, notice, customer, setting

        var title: String {
            switch self {
            case .invite: return "친구초대"
            case .notice: return "공지사항"
            case .customer: return "고객센터"
            case .setting: return "환경설정"
            }
        }

        var image: UIImage {
            switch self {
            case .invite: return #imageLiteral(resourceName: "icon_friend_w24h24")
            case .notice: return #imageLiteral(resourceName: "icon_sound_w24h24")
            case .customer: return #imageLiteral(resourceName: "icon_contact_w24h24")
            case .setting: return #imageLiteral(resourceName: "icon_setting_w24h24")
            }
        }
    }

    private let menus: Observable<[Menu]> = .just([.invite, .notice, .customer, .setting])

    lazy var navigationBar = NavigationBar(
        leftView: buttonBack,
        rightViews: [buttonAlert]
    ).then {
        $0.backgroundColor = .clear
    }

    let tableView = UITableView().then {
        $0.register(MenuCell.self, forCellReuseIdentifier: "cell")
        $0.rowHeight = 56
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
        $0.backgroundColor = 0xEEEEEE.color
    }
    let imageViewProfile = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = #imageLiteral(resourceName: "image_default_profile_w60h54")
    }
    let labelUsername = UILabel().then {
        $0.text = "노소영"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    let buttonEdit = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_indicator_w24h24"), for: .normal)
    }

    let buttonPay = VerticalButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_card_w48h48"), for: .normal)
        $0.setTitle("결제정보", for: .normal)
        $0.setTitleColor(Color.buttonTitle, for: .normal)
        $0.imageView?.contentMode = .center
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.titleLabel?.textAlignment = .center
    }
    let buttonPurchase = VerticalButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_cart_w48h48"), for: .normal)
        $0.setTitle("구매내역", for: .normal)
        $0.setTitleColor(Color.buttonTitle, for: .normal)
        $0.imageView?.contentMode = .center
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.titleLabel?.textAlignment = .center
    }
    let buttonLike = VerticalButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_heart_w48h48"), for: .normal)
        $0.setTitle("관심정보", for: .normal)
        $0.setTitleColor(Color.buttonTitle, for: .normal)
        $0.imageView?.contentMode = .center
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.titleLabel?.textAlignment = .center
    }

    override func setupConstraints() {
        setupNavigationBar()
        setupTableView()
        setupProfile()
        setupInfo()
    }

    override func setupBindings() {
        buttonBack.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        menus
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: MenuCell.self)) { _, menu, cell in
                cell.imageViewIcon.image = menu.image
                cell.labelTitle.text = menu.title
            }.disposed(by: disposeBag)

        tableView.rx.modelSelected(Menu.self)
            .filter { $0 == .setting }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let reactor = SettingReactor(provider: self.provider)
                let setting = SettingViewController(provider: self.provider, reactor: reactor)
                self.navigationController?.pushViewController(setting, animated: true)
            })
            .disposed(by: disposeBag)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let header = tableView.tableHeaderView {
            header.frame.size.height = 248
        }
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
            $0.top.equalToSuperview().inset(13)
            $0.leading.trailing.equalTo(viewContainer.safeAreaLayoutGuide).inset(15).priority(999)
            $0.height.equalTo(100)
        }
        viewProfile.addSubview(imageViewProfile)
        imageViewProfile.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(22)
            $0.width.equalTo(imageViewProfile.snp.height).priority(999)
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
            $0.leading.equalTo(imageViewProfile.snp.trailing).offset(14).priority(999)
            $0.trailing.equalTo(buttonEdit.snp.leading).offset(-14)
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
            $0.height.equalTo(87)
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
