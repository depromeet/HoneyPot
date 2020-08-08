//
//  SearchViewController.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/02.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SwiftyColor
import SnapKit
import Then
import RxGesture

class SearchViewController: BaseViewController, ReactorKit.View {
    private enum Color {
        static let navigationBackground = 0xFFD136.color
    }
    private enum Metric {
        static let textFieldViewFrame = CGRect(x: 0, y: 0, width: 80, height: 0)
    }

    lazy var navigationBar = NavigationBar(
        leftView: buttonBack
    ).then {
        $0.backgroundColor = .clear
    }

    let buttonBack = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_back_w24h24"), for: .normal)
    }
    let imageViewSearch = UIImageView().then {
        $0.contentMode = .center
        $0.image = #imageLiteral(resourceName: "icon_search_w24h24")
    }
    let buttonSearch = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_close_hexagon_w24h24"), for: .normal)
    }
    lazy var textFieldSearch = UITextField().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .white
        $0.placeholder = "검색어를 입력해주세요"
        $0.font = .systemFont(ofSize: 14)
        $0.leftView = imageViewSearch
        $0.leftViewMode = .always
        $0.rightView = buttonSearch
        $0.rightViewMode = .always
    }
    let tableView = UITableView().then {
        $0.rowHeight = 40
    }

    init(reactor: SearchReactor) {
        super.init(provider: reactor.provider)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupConstraints() {
        setupNavigationBar()
        setupTableView()
    }

    func bind(reactor: SearchReactor) {
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)

        textFieldSearch.rx.controlEvent(.editingChanged)
            .withLatestFrom(textFieldSearch.rx.text.orEmpty)
            .distinctUntilChanged()
            .map { Reactor.Action.inputSearchText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.searchText }
            .map { $0.isEmpty }
            .distinctUntilChanged()
            .bind(to: buttonSearch.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

extension SearchViewController {
    private func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(44)
        }
        navigationBar.addSubview(textFieldSearch)
        textFieldSearch.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(53)
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(30)
        }
        imageViewSearch.snp.makeConstraints {
            $0.width.equalTo(40)
        }
        buttonSearch.snp.makeConstraints {
            $0.width.equalTo(40)
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
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
