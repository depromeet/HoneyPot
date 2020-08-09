//
//  ListViewController.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/09.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture
import RxViewController
import RxDataSources
import ReusableKit
import RxReusableKit
import SwiftyColor
import SnapKit
import Then

class ListViewController: BaseViewController {
    private enum Color {
        static let navigationBackground = 0xFFD136.color
    }
    struct Reusable {
        static let itemCell = ReusableCell<ItemCell>()
    }

    lazy var navigationBar = NavigationBar(
        leftView: buttonBack
    ).then {
        $0.backgroundColor = .clear
    }

    let buttonBack = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_back_w24h24"), for: .normal)
    }
    let buttonSort = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_arrow_down_w24h24"), for: .normal)
        $0.setTitle("추천순", for: .normal)
        $0.setTitleColor(0x323232.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    let tableView = UITableView().then {
        $0.register(Reusable.itemCell)
        $0.contentInsetAdjustmentBehavior = .never
        $0.backgroundColor = .systemBackground
        $0.separatorStyle = .none
        $0.clipsToBounds = false
    }

    override func setupConstraints() {
        setupNavigationBar()
        setupTableView()

        // 임시 데이터
        Observable.of([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            .bind(to: tableView.rx.items(Reusable.itemCell)) { i, data, cell in
                print(i, data, cell)
            }
            .disposed(by: disposeBag)
    }
}

extension ListViewController {
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
        view.insertSubview(tableView, at: 0)
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        let viewHeader = UIView(frame: .init(x: 0, y: 0, width: 0, height: 30)).then {
            $0.backgroundColor = .clear
        }
        viewHeader.addSubview(buttonSort)
        buttonSort.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.trailing.equalToSuperview().inset(10)
        }
        tableView.tableHeaderView = viewHeader
    }
}
