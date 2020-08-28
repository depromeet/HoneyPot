//
//  PageCell.swift
//  Depromeet8th4
//
//  Created by 최은지 on 2020/08/06.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Then
import UIKit

class PageCell: UICollectionViewCell {
    let productTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white

        addSubview(productTableView)

        productTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        productTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        productTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        productTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.register(UINib(nibName: ProductCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: ProductCell.reusableIdentifier)
        productTableView.register(UINib(nibName: SortCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: SortCell.reusableIdentifier)
    }
}

extension PageCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 5
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SortCell.reusableIdentifier) as! SortCell
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reusableIdentifier) as! ProductCell
            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 37
        } else {
            return 377
        }
    }
}
