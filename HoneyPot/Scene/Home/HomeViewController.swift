//
//  HomeViewController.swift
//  HoneyPot
//
//  Created by Soso on 2020/08/25.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import RxSwift
import UIKit

class HomeViewController: BaseViewController {
    let categories = ["전체", "살림", "패션", "뷰티", "푸드", "가전", "스포츠", "잡화"]

    private enum Color {
        static let navigationBackground = 0xFFD136.color
        static let normalText = 0x686868.color
        static let focusedText = 0x323232.color
    }

    private enum Font {
        static let normalText = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)!
        static let focusedText = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)!
    }

    lazy var navigationBar = NavigationBar(
        rightViews: [buttonSearch, buttonAccount]
    ).then {
        $0.backgroundColor = .clear
    }

    let buttonSearch = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_search_w24h24"), for: .normal)
    }

    let buttonAccount = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_my_w24h24"), for: .normal)
    }

    lazy var pagerBar = PagerBar(subviews: buttons).then {
        $0.backgroundColor = .systemBackground
    }

    lazy var buttons = categories.map { title -> UIButton in
        UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(Color.normalText, for: .normal)
            $0.titleLabel?.font = Font.normalText
        }
    }

    lazy var listViewController = ListViewController(
        reactor: .init(provider: provider)
    ).then {
        if let reactor = $0.reactor {
            var list = categories
            list[0] = ""
            let taps = zip(buttons, list).map { button, category in
                button.rx.tap.map { category }
            }
            Observable.from(taps)
                .merge()
                .distinctUntilChanged()
                .map { ListReactor.Action.selectCategory($0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }

    override func setupConstraints() {
        setupNavigationBar()
        setupPagerBar()
        setupListViewController()
    }

    override func setupBindings() {
        let tappedButton = Observable
            .from(buttons.map { button in button.rx.tap.map { button } })
            .merge()
            .share()

        buttons.enumerated().forEach { index, button in
            tappedButton
                .map { $0 == button }
                .subscribe(onNext: { isTapped in
                    if isTapped {
                        button.titleLabel?.font = Font.focusedText
                        button.setTitleColor(Color.focusedText, for: .normal)
                    } else {
                        button.titleLabel?.font = Font.normalText
                        button.setTitleColor(Color.normalText, for: .normal)
                    }
                })
                .disposed(by: disposeBag)

            button.rx.tap
                .map { index }
                .bind(to: pagerBar.rx.currentIndex)
                .disposed(by: disposeBag)
        }

        buttonSearch.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let viewController = SearchViewController(reactor: .init(provider: self.provider))
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)

        buttonAccount.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let viewController = MyPageViewController(reactor: .init(provider: self.provider))
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
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
        buttons.first?.titleLabel?.font = Font.focusedText
        buttons.first?.setTitleColor(Color.focusedText, for: .normal)
    }

    private func setupPagerBar() {
        view.addSubview(pagerBar)
        pagerBar.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(36)
        }
        let viewSeparator = UIView().then {
            $0.backgroundColor = 0xEEEEEE.color
        }
        view.addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.top.equalTo(pagerBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    private func setupListViewController() {
        addChild(listViewController)
        view.addSubview(listViewController.view)
        listViewController.view.snp.makeConstraints {
            $0.top.equalTo(pagerBar.snp.bottom).offset(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        listViewController.didMove(toParent: self)
    }
}
