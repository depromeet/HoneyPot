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
    }

    lazy var navigationBar = NavigationBar(
        leftView: buttonBack,
        rightView: buttonAlert
    ).then {
        $0.backgroundColor = .clear
    }
    let buttonBack = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_back_w24h24"), for: .normal)
    }
    let buttonAlert = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_alert_w24h24"), for: .normal)
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

    override func setupConstraints() {
        setupNavigationBar()
        setupProfile()
    }

    override func setupBindings() {
        buttonBack.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageViewController {
    private func setupNavigationBar() {
        view.backgroundColor = Color.navigationBackground
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(44)
        }
    }
    private func setupProfile() {
        let viewContainer = UIView().then {
            $0.backgroundColor = .systemBackground
        }
        view.addSubview(viewContainer)
        viewContainer.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        let viewProfile = UIView().then {
            $0.layer.cornerRadius = 10
            $0.backgroundColor = 0xEEEEEE.color
        }
        viewContainer.addSubview(viewProfile)
        viewProfile.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.leading.trailing.equalTo(viewContainer.safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(100)
        }
        viewProfile.addSubview(imageViewProfile)
        imageViewProfile.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(22)
            $0.width.equalTo(imageViewProfile.snp.height)
        }
        viewProfile.addSubview(buttonEdit)
        buttonEdit.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(44)
        }
        viewProfile.addSubview(labelUsername)
        labelUsername.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(imageViewProfile.snp.trailing).offset(14)
            $0.trailing.equalTo(buttonEdit.snp.leading).offset(14)
        }
    }
}
