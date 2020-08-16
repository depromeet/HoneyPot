//
//  SortModalViewController.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/16.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal
import SwiftyColor

class SortModalViewController: BaseViewController {
    var titles: [String]
    var selectedIndex: Int

    let tableView = ResizableTableView().then {
        $0.register(BottomSheetItemCell.self, forCellReuseIdentifier: "cell")
        $0.separatorColor = 0xCCCCCC.color
        $0.separatorStyle = .singleLine
        $0.separatorInset = .init(top: 0, left: 18, bottom: 0, right: 18)
        $0.tableHeaderView = .init(frame: .init(x: 0, y: 0, width: 0, height: 15))
        $0.tableFooterView = .init(frame: .init(x: 0, y: 0, width: 0, height: 4))
        $0.rowHeight = 40
        $0.bounces = false
    }

    init(
        provider: ServiceProviderType,
        titles: [String],
        selectedIndex: Int = 0
    ) {
        self.titles = titles
        self.selectedIndex = selectedIndex
        super.init(provider: provider)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupConstraints() {
        setupViews()
    }

    override func setupBindings() {
        Observable.just(titles)
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: BottomSheetItemCell.self)) { [weak self] index, title, cell in
                cell.labelTitle.text = title

                if let self = self, self.selectedIndex == index {
                    self.tableView.selectRow(at: IndexPath(row: self.selectedIndex, section: 0), animated: false, scrollPosition: .none)
                }
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: SortModalViewController {
    var itemSelected: ControlEvent<IndexPath> {
        return base.tableView.rx.itemSelected
    }
}

extension SortModalViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SortModalViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        return .contentHeight(tableView.intrinsicContentSize.height)
    }

    var longFormHeight: PanModalHeight {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        return .contentHeight(tableView.intrinsicContentSize.height)
    }

    var panModalBackgroundColor: UIColor {
        return 0x323232.color ~ 50%
    }
}
