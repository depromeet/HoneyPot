//
//  SettingViewController.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/02.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class SettingViewController: BaseViewController, View {
    private enum Color {
        static let navigationBackground = 0xFFD136.color
    }

    lazy var navigationBar = NavigationBar(
        leftView: buttonBack
    ).then {
        $0.backgroundColor = .clear
    }

    let buttonBack = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_back_w24h24"), for: .normal)
    }

    let textFieldUserID = UITextField().then {
        $0.borderStyle = .roundedRect
    }

    init(reactor: SettingReactor) {
        super.init(provider: reactor.provider)
        self.reactor = reactor
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        textFieldUserID.becomeFirstResponder()
    }

    override func setupConstraints() {
        setupNavigationBar()
        setupTextField()
    }

    func bind(reactor: SettingReactor) {
        buttonBack.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        textFieldUserID.rx.controlEvent(.editingChanged)
            .withLatestFrom(textFieldUserID.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .map { Reactor.Action.setUserID($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.userID }
            .distinctUntilChanged()
            .bind(to: textFieldUserID.rx.text)
            .disposed(by: disposeBag)
    }
}

extension SettingViewController {
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

    private func setupTextField() {
        view.addSubview(textFieldUserID)
        textFieldUserID.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
