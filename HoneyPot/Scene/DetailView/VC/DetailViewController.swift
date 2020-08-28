//
//  DetailViewController.swift
//  Depromeet8th4
//
//  Created by Yeojaeng on 2020/08/05.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerXib()
        setupNavigationBar()
    }

    func registerXib() {
        let productImageCell = UINib(nibName: "ProductImageCell", bundle: nil)
        let productRelatedCell = UINib(nibName: "ProductRelatedCell", bundle: nil)
        let progressAndPromoterCell = UINib(nibName: "ProgressAndPromoterCell", bundle: nil)
        let productDetailImageCell = UINib(nibName: "ProductDetailImageCell", bundle: nil)
        let commentTopCell = UINib(nibName: "CommentTopCell", bundle: nil)
        let commentCell = UINib(nibName: "CommentCell", bundle: nil)
        let functionCell = UINib(nibName: "FunctionCell", bundle: nil)
        tableView.register(productImageCell, forCellReuseIdentifier: "ProductImageCell")
        tableView.register(productRelatedCell, forCellReuseIdentifier: "ProductRelatedCell")
        tableView.register(progressAndPromoterCell, forCellReuseIdentifier: "ProgressAndPromoterCell")
        tableView.register(productDetailImageCell, forCellReuseIdentifier: "ProductDetailImageCell")
        tableView.register(commentTopCell, forCellReuseIdentifier: "CommentTopCell")
        tableView.register(commentCell, forCellReuseIdentifier: "CommentCell")
        tableView.register(functionCell, forCellReuseIdentifier: "FunctionCell")
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .systemBackground
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 7
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            let cell: ProductImageCell = tableView.dequeueReusableCell(withIdentifier: "ProductImageCell") as! ProductImageCell
            return cell
        case 1:
            let cell: ProductRelatedCell = tableView.dequeueReusableCell(withIdentifier: "ProductRelatedCell") as! ProductRelatedCell
            return cell
        case 2:
            let cell: ProgressStatusAndPromoterCell = tableView.dequeueReusableCell(withIdentifier: "ProgressStatusAndPromoterCell") as! ProgressStatusAndPromoterCell
            return cell
        case 3:
            let cell: ProductDetailImageCell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailImageCell") as! ProductDetailImageCell
            return cell
        case 4:
            let cell: CommentTopCell = tableView.dequeueReusableCell(withIdentifier: "CommentTopCell") as! CommentTopCell
            return cell
        case 5:
            let cell: CommentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            cell.delegate = self
            return cell
        case 6:
            let cell: FunctionCell = tableView.dequeueReusableCell(withIdentifier: "FunctionCell") as! FunctionCell
            return cell
        default:
            let cell: UITableViewCell = UITableViewCell()
            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 375.0
        case 1:
            return 131.0
        case 2:
            return 200.0
        case 3:
            return 283.0
        case 4:
            return 113.0
        case 5:
            return 102.0
        case 6:
            return 113.0
        default:
            return 0.0
        }
    }
}
