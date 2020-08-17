//
//  DiscountModalViewController.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/17.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyColor
import SnapKit
import Then

class DiscountModalViewController: BaseViewController {
    var discounts: [DiscountEntity]

    let labelTitle = UILabel().then {
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        $0.textColor = 0x464646.color
        $0.text = "할인혜택 안내"
    }
    let buttonClose = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_close_w8h8"), for: .normal)
    }

    let tableView = ResizableTableView().then {
        $0.register(DiscountCell.self, forCellReuseIdentifier: "cell")
        $0.separatorColor = 0xCCCCCC.color
        $0.separatorStyle = .none
        $0.rowHeight = 34
        $0.bounces = false
        $0.maxHeight = 0
    }

    init(
        provider: ServiceProviderType,
        discounts: [DiscountEntity]
    ) {
        self.discounts = discounts
        super.init(provider: provider)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupConstraints() {
        setupViews()
    }

    override func setupBindings() {
        buttonClose.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        Observable.just(discounts)
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: DiscountCell.self)) { _, discount, cell in
                let textPercent = "\(discount.discountPercent)% 할인"
                let textNumber = "\(discount.numberOfPeople)명 도달 시"
                cell.labelPercent.text = textPercent
                cell.labelCount.text = textNumber
                switch discount.step {
                case 1:
                    cell.imageViewStep.image = #imageLiteral(resourceName: "icon_discount_step1_w20h17")
                case 2:
                    cell.imageViewStep.image = #imageLiteral(resourceName: "icon_discount_step2_w20h17")
                case 3:
                    cell.imageViewStep.image = #imageLiteral(resourceName: "icon_discount_step3_w20h17")
                default:
                    cell.imageViewStep.image = nil
                }
            }
            .disposed(by: disposeBag)
    }
}

extension DiscountModalViewController {
    private func setupViews() {
        view.backgroundColor = 0x323232.color ~ 50%

        let viewBackground = UIView().then {
            $0.backgroundColor = .systemBackground
            $0.layer.cornerRadius = 5
        }
        view.addSubview(viewBackground)
        viewBackground.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(245)
        }
        viewBackground.addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
        }
        viewBackground.addSubview(buttonClose)
        buttonClose.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(38)
        }
        let viewSeparator = UIView().then {
            $0.backgroundColor = 0xEEEEEE.color
        }
        viewBackground.addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.top.equalTo(buttonClose.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        viewBackground.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(viewSeparator.snp.bottom).offset(9)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(9)
        }
    }
}
