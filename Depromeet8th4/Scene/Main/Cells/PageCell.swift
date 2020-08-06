//
//  PageCell.swift
//  Depromeet8th4
//
//  Created by 최은지 on 2020/08/06.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import Then

class PageCell: UICollectionViewCell {

    var sortButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_expand_w24h24"), for: .normal)
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var productTableView = UITableView().then {
        $0.backgroundColor = .yellow
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white

        self.addSubview(sortButton)
        sortButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        sortButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        self.sortButton.addTarget(self, action: #selector(clickSortButton), for: .touchUpInside)
        
        self.addSubview(productTableView)
        
        
        productTableView.topAnchor.constraint(equalTo: self.sortButton.bottomAnchor).isActive = true
        productTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        productTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        productTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.register(UINib(nibName: ProductCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: ProductCell.reusableIdentifier)
    }
    
    @objc func clickSortButton(){
        print("click sort🌟")
    }
    
}

extension PageCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reusableIdentifier) as! ProductCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
}
