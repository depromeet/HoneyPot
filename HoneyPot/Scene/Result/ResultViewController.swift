//
//  ResultViewController.swift
//  HoneyPot
//
//  Created by Soso on 2020/08/25.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class ResultViewController: BaseViewController {
    let keyword: String

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

    lazy var listViewController = ListViewController(
        reactor: .init(provider: provider, keyword: keyword)
    )

    init(provider: ServiceProviderType, keyword: String) {
        self.keyword = keyword
        super.init(provider: provider)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupConstraints() {
        setupNavigationBar()
        setupListViewController()
    }

    override func setupBindings() {
        buttonBack.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension ResultViewController {
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
        navigationBar.labelTitle.text = keyword
    }

    private func setupListViewController() {
        addChild(listViewController)
        view.addSubview(listViewController.view)
        listViewController.view.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        listViewController.didMove(toParent: self)
    }
}
