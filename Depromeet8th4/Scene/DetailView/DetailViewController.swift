//
//  DetailViewController.swift
//  Depromeet8th4
//
//  Created by Yeojaeng on 2020/08/05.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    //MARK:- Properties & Setting Methods.
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
    }
    
    func registerXib() {
        tableView.register(ProductImageCell.self, forCellReuseIdentifier: "ProductImageCell")
        tableView.register(ProductRelatedCell.self, forCellReuseIdentifier: "ProductRelatedCell")
        tableView.register(ProgressStatusAndPromoterCell.self, forCellReuseIdentifier: "ProgressDetailImageCell")
        tableView.register(CommentTopCell.self, forCellReuseIdentifier: "CommentTopCell")
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.register(FunctionCell.self, forCellReuseIdentifier: "FunctionCell")
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    //MARK:- DataSource & Delegate Methods.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 5:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: ProductImageCell = ProductImageCell()
            return cell
        case 1:
            let cell: ProductRelatedCell = ProductRelatedCell()
            return cell
        case 2:
            let cell: ProgressStatusAndPromoterCell = ProgressStatusAndPromoterCell()
            return cell
        case 3:
            let cell: ProductDetailImageCell = ProductDetailImageCell()
            return cell
        case 4:
            let cell: CommentTopCell = CommentTopCell()
            return cell
        case 5:
            let cell: CommentCell = CommentCell()
            return cell
        case 6:
            let cell: FunctionCell = FunctionCell()
            return cell
        default:
            let cell: UITableViewCell = UITableViewCell()
            return cell
        }
    }
}

