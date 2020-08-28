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
import RxViewController
import RxDataSources
import ReusableKit
import RxReusableKit
import RxGesture
import SwiftyColor
import SnapKit
import Then

enum SortKind: String, CaseIterable {
    case suggestion = "RECOMMEND"
    case popular = "LIKE"
    case recent = "NEW"
    case closing = "CLOSE"
    case cheap = "PRICE"

    var title: String {
        switch self {
        case .suggestion: return "추천순"
        case .popular: return "인기순"
        case .recent: return "최신순"
        case .closing: return "마감임박순"
        case .cheap: return "가격낮은순"
        }
    }
}

class ListViewController: BaseViewController, ReactorKit.View {
    struct Reusable {
        static let itemCell = ReusableCell<ItemCell>()
    }

    let buttonSort = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_arrow_down_w24h24"), for: .normal)
        $0.setTitle("추천순", for: .normal)
        $0.setTitleColor(0x323232.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.titleEdgeInsets = .init(top: 0, left: 4, bottom: 0, right: -4)
    }
    let tableView = UITableView().then {
        $0.register(Reusable.itemCell)
        $0.contentInsetAdjustmentBehavior = .never
        $0.backgroundColor = .systemBackground
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 380
    }
    let refreshControl = UIRefreshControl().then {
        $0.backgroundColor = .clear
    }
    let activityIndicator = UIActivityIndicatorView(
        frame: .init(x: 0, y: 0, width: 0, height: 30)
    ).then {
        $0.hidesWhenStopped = true
    }

    init(reactor: ListReactor) {
        super.init(provider: reactor.provider)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupConstraints() {
        setupTableView()
    }

    func bind(reactor: ListReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    private func bindAction(reactor: ListReactor) {
        rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        buttonSort.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let modal = SortModalViewController(
                    provider: self.provider,
                    titles: reactor.currentState.sortList.map { $0.title },
                    selectedIndex: reactor.currentState.sortIndex
                )
                self.presentPanModal(modal)

                modal.rx.itemSelected
                    .distinctUntilChanged()
                    .map { $0.row }
                    .map { Reactor.Action.selectSortIndex($0) }
                    .bind(to: reactor.action)
                    .disposed(by: modal.disposeBag)
            })
            .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        let tableView = self.tableView

        tableView.rx.contentOffset
            .skip(1)
            .map { $0.y >= tableView.contentSize.height - tableView.bounds.height }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        tableView.rx.didEndDragging
            .withLatestFrom(reactor.state)
            .map { $0.isRefreshing }
            .filter { _ in tableView.contentOffset.y < 0 }
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(ItemEntity.self)
            .map { $0.id }
            .subscribe(onNext: { [weak self] id in
                guard let self = self else { return }
                let viewController = ItemViewController(reactor: .init(provider: self.provider, itemID: id))
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    private func bindState(reactor: ListReactor) {
        reactor.state
            .map { $0.sortTitle }
            .distinctUntilChanged()
            .skip(1)
            .subscribe(onNext: { [weak self] title in
                self?.buttonSort.setTitle(title, for: .normal)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.items }
            .distinctUntilChanged()
            .bind(to: tableView.rx.items(Reusable.itemCell)) { _, item, cell in
                cell.setData(item: item)
            }
            .disposed(by: disposeBag)

        let tableView = self.tableView
        reactor.state
            .map { $0.isRefreshing }
            .filter({ $0 || !tableView.isDragging })
            .distinctUntilChanged()
            .filter { !$0 }
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

extension ListViewController {
    private func setupTableView() {
        view.insertSubview(tableView, at: 0)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        let viewHeader = UIView(frame: .init(x: 0, y: 0, width: 0, height: 30)).then {
            $0.backgroundColor = .clear
        }
        viewHeader.addSubview(buttonSort)
        buttonSort.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.trailing.equalToSuperview().inset(10)
        }
        tableView.refreshControl = refreshControl
        tableView.tableHeaderView = viewHeader
        tableView.tableFooterView = activityIndicator
    }
}
