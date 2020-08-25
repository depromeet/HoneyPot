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
import RxDataSources
import ReusableKit

class CommentViewController: BaseViewController, View {
    var isTyping: Bool

    private enum Color {
        static let yellow1 = 0xFFD136.color
        static let black1 = 0x323232.color
        static let lightGray1 = 0xA5A5A5.color
        static let lightGray2 = 0xF8F8F8.color
        static let lightGray4 = 0xCACACA.color
    }
    private enum Font {
        static let sdR14 = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
        static let sdR12 = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)!
    }
    struct Reusable {
        static let commentCell = ReusableCell<ItemCommentCell>()
        static let subCommentCell = ReusableCell<ItemSubCommentCell>()
    }

    lazy var navigationBar = NavigationBar(
        title: "댓글 전체보기",
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

    let viewInput = UIView().then {
        $0.backgroundColor = .systemBackground
    }
    let textViewInput = ResizableTextView().then {
        $0.font = Font.sdR14
        $0.textColor = Color.black1
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
    }
    let buttonSend = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_write_selected_w16h16"), for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icon_write_w16h16"), for: .disabled)
        $0.adjustsImageWhenHighlighted = false
    }
    let labelInputPlaceholder = UILabel().then {
        $0.font = Font.sdR14
        $0.textColor = Color.lightGray4
        $0.text = "댓글 달기"
    }
    var constraintInputBottom: NSLayoutConstraint!
    let viewReply = UIView().then {
        $0.backgroundColor = Color.lightGray2
    }
    let labelReply = UILabel().then {
        $0.textColor = Color.lightGray1
        $0.font = Font.sdR12
    }
    let buttonReplyClose = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_close_w10h10"), for: .normal)
    }
    var constraintReplyBottom: NSLayoutConstraint!

    let refreshControl = UIRefreshControl().then {
        $0.backgroundColor = .clear
    }
    let activityIndicator = UIActivityIndicatorView(
        frame: .init(x: 0, y: 0, width: 0, height: 100)
    ).then {
        $0.hidesWhenStopped = true
    }

    init(reactor: CommentReactor, isTyping: Bool) {
        self.isTyping = isTyping
        super.init(provider: reactor.provider)
        self.reactor = reactor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var dataSource = RxTableViewSectionedReloadDataSource
        <CommentSection>(configureCell: { [weak self] _, tableView, indexPath, sectionItem in
            guard let self = self,
                let reactor = self.reactor
                else { return .init() }
            let userID = self.provider.accountService.userID
            switch sectionItem {
            case .comment(let comment):
                let cell = tableView.dequeue(Reusable.commentCell, for: indexPath)
                cell.setData(comment: comment, isExpandable: true)
                cell.buttonReply.rx.tap
                    .map { Reactor.Action.selectIndexPath(indexPath) }
                    .do(onNext: { _ in self.textViewInput.becomeFirstResponder() })
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
                cell.buttonMore.rx.tap
                    .map { (indexPath, comment.author.userId == userID) }
                    .subscribe(onNext: self.presentCommentActionSheet)
                    .disposed(by: cell.disposeBag)
                cell.buttonLike.rx.tap
                    .map { Reactor.Action.likeComment(indexPath) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
                cell.buttonBottom.rx.tap
                    .map { Reactor.Action.toggleComment(indexPath) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
                return cell
            case .subcomment(let comment):
                let cell = tableView.dequeue(Reusable.subCommentCell, for: indexPath)
                cell.setData(comment: comment)
                cell.buttonMore.rx.tap
                    .map { (indexPath, comment.author.userId == userID) }
                    .subscribe(onNext: self.presentCommentActionSheet)
                    .disposed(by: cell.disposeBag)
                cell.buttonLike.rx.tap
                    .map { Reactor.Action.likeComment(indexPath) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
                return cell
            }
        })

    override func setupConstraints() {
        setupNavigationBar()
        setupTableView()
        setupInputView()
        setupSelected()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if isTyping {
            textViewInput.becomeFirstResponder()
        }
    }

    func bind(reactor: CommentReactor) {
        bindView(reactor: reactor)
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    private func bindView(reactor: CommentReactor) {
        buttonBack.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        textViewInput.rx.text.orEmpty
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(to: buttonSend.rx.isEnabled)
            .disposed(by: disposeBag)

        textViewInput.rx.text.orEmpty
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(to: labelInputPlaceholder.rx.isHidden)
            .disposed(by: disposeBag)

        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] height in
                let constant = height - self.view.safeAreaInsets.bottom
                self.constraintInputBottom?.constant = -max(constant, 0)
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    private func bindAction(reactor: CommentReactor) {
        rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        let textViewInput = self.textViewInput
        buttonSend.rx.tap
            .withLatestFrom(textViewInput.rx.text.orEmpty)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .map { Reactor.Action.addComment($0) }
            .do(onNext: { _ in textViewInput.text = nil  })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        buttonReplyClose.rx.tap
            .map { Reactor.Action.selectIndexPath(nil) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        let tableView = self.tableView

        tableView.rx.contentOffset
            .skip(1)
            .map { $0.y >= tableView.contentSize.height - tableView.bounds.height }
            .distinctUntilChanged()
            .map { _ in Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    private func bindState(reactor: CommentReactor) {
        reactor.state
            .map { $0.isRefreshing }
            .distinctUntilChanged()
            .filter { !$0 }
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.comments }
            .distinctUntilChanged()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.selectedText }
            .distinctUntilChanged()
            .bind(to: labelReply.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.selectedIndexPath == nil }
            .distinctUntilChanged()
            .map { $0 ? "댓글 달기" : "답글 달기" }
            .bind(to: labelInputPlaceholder.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.selectedIndexPath != nil }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] selected in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.2) {
                    if selected {
                        self.constraintReplyBottom.constant = 0
                    } else {
                        self.constraintReplyBottom.constant = 45
                    }
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }

    private func presentCommentActionSheet(indexPath: IndexPath, isOwner: Bool) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if isOwner {
            let actionEdit = UIAlertAction(title: "수정", style: .default, handler: nil)
            let actionDelete = UIAlertAction(title: "삭제하기", style: .destructive, handler: { [weak self] action in
                self?.reactor?.action.onNext(.deleteComment(indexPath))
            })
            actionSheet.addAction(actionEdit)
            actionSheet.addAction(actionDelete)
        } else {
            let actionReport = UIAlertAction(title: "신고", style: .default, handler: nil)
            actionSheet.addAction(actionReport)
        }
        let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
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
        }
//        tableView.refreshControl = refreshControl
        tableView.tableFooterView = activityIndicator
    }
    private func setupInputView() {
        view.addSubview(viewInput)
        viewInput.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        constraintInputBottom = viewInput.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        constraintInputBottom.isActive = true
        let viewBackground = UIView().then {
            $0.backgroundColor = Color.lightGray2
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        viewInput.addSubview(viewBackground)
        viewBackground.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().inset(18).priority(999)
        }
        viewBackground.addSubview(textViewInput)
        textViewInput.snp.makeConstraints {
            $0.top.equalToSuperview().inset(1)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(32).priority(999)
        }
        viewBackground.addSubview(buttonSend)
        buttonSend.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        viewBackground.addSubview(labelInputPlaceholder)
        labelInputPlaceholder.snp.makeConstraints {
            $0.leading.equalTo(textViewInput).inset(5)
            $0.centerY.equalTo(textViewInput)
        }
        let viewSeparator = UIView().then {
            $0.backgroundColor = 0xCACACA.color
        }
        viewInput.addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-1)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    private func setupSelected() {
        view.insertSubview(viewReply, belowSubview: viewInput)
        viewReply.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(45)
        }
        constraintReplyBottom = viewReply.bottomAnchor.constraint(equalTo: viewInput.topAnchor)
        constraintReplyBottom.isActive = true
        constraintReplyBottom.constant = 45
        viewReply.addSubview(labelReply)
        labelReply.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
        }
        viewReply.addSubview(buttonReplyClose)
        buttonReplyClose.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(labelReply.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(4)
            $0.width.equalTo(buttonReplyClose.snp.height)
        }
        let viewSeparator = UIView().then {
            $0.backgroundColor = 0xCACACA.color
        }
        viewReply.addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
