//
//  CommentViewController.swift
//  Development
//
//  Created by Soso on 2020/08/19.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxKeyboard
import ReusableKit

class CommentViewController: BaseViewController, View {

    private enum Color {
        static let yellow1 = 0xFFD136.color
    }
    struct Reusable {
        static let commentCell = ReusableCell<ItemCommentCell>()
        static let subCommentCell = ReusableCell<ItemSubCommentCell>()
    }

    lazy var navigationBar = NavigationBar(
        leftView: buttonBack
    ).then {
        $0.backgroundColor = .clear
    }
    let buttonBack = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_back_w24h24"), for: .normal)
    }

    let tableView = UITableView().then {
        $0.register(Reusable.commentCell)
        $0.register(Reusable.subCommentCell)
        $0.contentInsetAdjustmentBehavior = .never
        $0.backgroundColor = .systemBackground
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .interactive
    }

    init(reactor: CommentReactor) {
        super.init(provider: reactor.provider)
        self.reactor = reactor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupConstraints() {
        setupNavigationBar()
        setupTableView()
    }

    func bind(reactor: CommentReactor) {
        buttonBack.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        Observable
            .just(["1", "2", "3", "4", "5", "6", "7", "8"])
            .bind(to: tableView.rx.items(Reusable.subCommentCell)) { index, data, cell in
                print(index, data, cell)
                cell.buttonMore.rx.tap
                    .subscribe(onNext: { [weak self] in
                        self?.presentCommentActionSheet()
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }

    private func presentCommentActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionEdit = UIAlertAction(title: "수정", style: .default, handler: nil)
        let actionDelete = UIAlertAction(title: "삭제하기", style: .destructive, handler: nil)
        let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        actionSheet.addAction(actionEdit)
        actionSheet.addAction(actionDelete)
        actionSheet.addAction(actionCancel)
        present(actionSheet, animated: true, completion: nil)
    }
}

extension CommentViewController {
    private func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(44)
        }
        let viewBackground = UIView().then {
            $0.backgroundColor = Color.yellow1
        }
        view.insertSubview(viewBackground, belowSubview: navigationBar)
        viewBackground.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationBar)
        }
    }
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
}
