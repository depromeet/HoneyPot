//
//  BottomSheet.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/11.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class BottomSheet: UIView {
    let disposeBag = DisposeBag()

    var titles: [String]
    var selectedIndex: Int {
        didSet {
            tableView.selectRow(at: IndexPath(row: selectedIndex, section: 0), animated: false, scrollPosition: .none)
        }
    }

    init(titles: [String], selectedIndex: Int = 0) {
        self.titles = titles
        self.selectedIndex = selectedIndex
        super.init(frame: .zero)

        setupViews()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let tableView = ResizableTableView().then {
        $0.register(BottomSheetItemCell.self, forCellReuseIdentifier: "cell")
        $0.separatorColor = 0xCCCCCC.color
        $0.separatorInset = .init(top: 0, left: 18, bottom: 0, right: 18)
        $0.separatorStyle = .singleLine
        $0.rowHeight = 40
        $0.bounces = false
    }

    private func setupViews() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4).priority(999)
        }
    }
    private func setupBindings() {
        Observable.just(titles)
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: BottomSheetItemCell.self)) { [weak self] index, title, cell in
                cell.labelTitle.text = title

                if let self = self, self.selectedIndex == index {
                    self.tableView.selectRow(at: IndexPath(row: self.selectedIndex, section: 0), animated: false, scrollPosition: .none)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: BottomSheet {
    var itemSelected: ControlEvent<IndexPath> {
        return base.tableView.rx.itemSelected
    }
}

class BottomSheetItemCell: BaseTableViewCell {
    private enum Color {
        static let normalTitle = 0xA5A5A5.color
        static let selectedTitle = 0x323232.color
    }
    private enum Font {
        static let normalTitle = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        static let selectedTitle = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
    }

    let labelTitle = UILabel().then {
        $0.textColor = Color.normalTitle
        $0.font = Font.normalTitle
    }
    let imageViewCheck = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "image_item_checked_w24h24")
        $0.isHidden = true
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                labelTitle.textColor = Color.selectedTitle
                labelTitle.font = Font.selectedTitle
            } else {
                labelTitle.textColor = Color.normalTitle
                labelTitle.font = Font.normalTitle
            }
            imageViewCheck.isHidden = !isSelected
        }
    }

    override func initialize() {
        selectionStyle = .none
        addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
        }
        addSubview(imageViewCheck)
        imageViewCheck.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            labelTitle.textColor = Color.selectedTitle
        } else {
            labelTitle.textColor = Color.normalTitle
        }
        imageViewCheck.isHidden = !selected
    }
}
