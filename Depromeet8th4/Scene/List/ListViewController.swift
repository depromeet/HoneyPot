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
    case suggestion, popular, recent, closing, cheap

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
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 390
    }

    let bottomSheet = BottomSheet(
        titles: SortKind.allCases.map { $0.title }
    ).then {
        $0.backgroundColor = .white
    }
    var bottomSheetTopConstraint: NSLayoutConstraint?
    let viewOverlay = UIView().then {
        $0.backgroundColor = 0x323232.color ~ 50%
        $0.alpha = 0
    }

    init(reactor: ListReactor) {
        super.init(provider: reactor.provider)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupConstraints() {
        setupNavigationBar()
        setupTableView()
        setupBottomSheet()
    }

    func bind(reactor: ListReactor) {
        rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        buttonBack.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        buttonSort.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleBottomSheet(true)
            })
            .disposed(by: disposeBag)

        bottomSheet.rx.itemSelected
            .distinctUntilChanged()
            .map { $0.row }
            .map { Reactor.Action.selectSortIndex($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let viewController = ItemViewController(reactor: .init(provider: self.provider, itemID: ""))
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)

        viewOverlay.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.toggleBottomSheet(false)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.sortTitle }
            .distinctUntilChanged()
            .skip(1)
            .do(onNext: { [weak self] _ in
                self?.toggleBottomSheet(false)
            })
            .subscribe(onNext: { [weak self] title in
                self?.buttonSort.setTitle(title, for: .normal)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.items }
            .distinctUntilChanged()
            .bind(to: tableView.rx.items(Reusable.itemCell)) { i, item, cell in
                print(i, item, cell)
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
    private func setupBottomSheet() {
        view.addSubview(viewOverlay)
        viewOverlay.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        view.addSubview(bottomSheet)
        bottomSheet.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        bottomSheetTopConstraint = bottomSheet.topAnchor.constraint(equalTo: view.bottomAnchor)
        bottomSheetTopConstraint?.isActive = true
    }
    private func toggleBottomSheet(_ isOpened: Bool) {
        var alpha: CGFloat
        var constant: CGFloat
        if isOpened {
            alpha = 1
            constant = -bottomSheet.bounds.height
        } else {
            alpha = 0
            constant = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetTopConstraint?.constant = constant
            self.viewOverlay.alpha = alpha
            self.view.layoutIfNeeded()
        }
    }
}
