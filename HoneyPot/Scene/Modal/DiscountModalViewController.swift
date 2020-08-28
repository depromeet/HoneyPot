//
//  DiscountModalViewController.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/17.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import SwiftyColor
import Then
import UIKit

class DiscountModalViewController: BaseViewController {
    var discounts: [DiscountEntity]

    let labelTitle = UILabel().then {
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        $0.textColor = 0x464646.color
        $0.text = "할인혜택 안내"
    }

    let buttonClose = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_close_w24h24"), for: .normal)
    }

    let tableView = ResizableTableView().then {
        $0.register(DiscountCell.self, forCellReuseIdentifier: "cell")
        $0.separatorColor = 0xCCCCCC.color
        $0.separatorStyle = .none
        $0.rowHeight = 31
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

    required init?(coder _: NSCoder) {
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
                    cell.imageViewStep.image = #imageLiteral(resourceName: "icon_discount_step1_w24h24")
                case 2:
                    cell.imageViewStep.image = #imageLiteral(resourceName: "icon_discount_step2_w24h24")
                case 3:
                    cell.imageViewStep.image = #imageLiteral(resourceName: "icon_discount_step3_w24h24")
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
            $0.width.equalTo(339)
        }
        viewBackground.addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        viewBackground.addSubview(buttonClose)
        buttonClose.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
            $0.width.height.equalTo(48)
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
            $0.top.equalTo(viewSeparator.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(18)
        }
        view.layoutIfNeeded()
    }
}
