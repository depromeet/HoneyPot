//
//  SearchViewController.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/02.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture
import RxViewController
import RxDataSources
import ReusableKit
import SwiftyColor
import SnapKit
import Then

class SearchViewController: BaseViewController, ReactorKit.View {
    private enum Color {
        static let navigationBackground = 0xFFD136.color
        static let placeholderText = 0xA5A5A5.color
    }
    private enum Metric {
        static let textFieldViewFrame = CGRect(x: 0, y: 0, width: 80, height: 0)
    }
    private enum Font {
        static let textFieldText = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
    }
    struct Reusable {
        static let searchCell = ReusableCell<SearchCell>()
        static let searchHeader = ReusableView<SearchHeader>()
    }

    lazy var dataSource = RxTableViewSectionedReloadDataSource<SearchSection>(
        configureCell: { [weak self] _, tableView, indexPath, item in
            let cell = tableView.dequeue(Reusable.searchCell, for: indexPath)
            cell.labelTitle.text = item
            if let reactor = self?.reactor {
                cell.buttonClose.rx.tap
                    .map { Reactor.Action.removeWord(item) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            return cell
        })

    lazy var navigationBar = NavigationBar(
        leftView: buttonBack
    ).then {
        $0.backgroundColor = .clear
    }

    let buttonBack = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_back_w24h24"), for: .normal)
    }
    let imageViewSearch = UIImageView().then {
        $0.contentMode = .center
        $0.image = #imageLiteral(resourceName: "icon_search_light_w24h24")
    }
    let buttonClear = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_close_hexagon_w24h24"), for: .normal)
    }
    lazy var textFieldSearch = UITextField().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .white
        $0.font = Font.textFieldText
        $0.leftView = imageViewSearch
        $0.leftViewMode = .always
        $0.rightView = buttonClear
        $0.rightViewMode = .always
        $0.autocorrectionType = .no
        $0.returnKeyType = .done
        let attributes: [NSAttributedString.Key: Any] = [
            .font: Font.textFieldText,
            .foregroundColor: Color.placeholderText
        ]
        let attributedString = NSAttributedString(string: "검색어를 입력해주세요", attributes: attributes)
        $0.attributedPlaceholder = attributedString
    }
    let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(Reusable.searchCell)
        $0.register(Reusable.searchHeader)
        $0.contentInsetAdjustmentBehavior = .never
        $0.backgroundColor = .systemBackground
        $0.separatorStyle = .none
        $0.rowHeight = 40
    }

    init(reactor: SearchReactor) {
        super.init(provider: reactor.provider)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        textFieldSearch.becomeFirstResponder()
    }

    override func setupConstraints() {
        setupNavigationBar()
        setupTableView()
    }

    func bind(reactor: SearchReactor) {
        rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        buttonBack.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        textFieldSearch.rx.controlEvent(.editingChanged)
            .withLatestFrom(textFieldSearch.rx.text.orEmpty)
            .distinctUntilChanged()
            .map { Reactor.Action.inputSearchText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        let keyboardTap = textFieldSearch.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(textFieldSearch.rx.text.orEmpty)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { String($0) }

        let cellTap = tableView.rx.modelSelected(String.self)
            .map { String($0) }
            .share()

        cellTap
            .map { Reactor.Action.inputSearchText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        Observable.of(keyboardTap, cellTap).merge()
            .map { Reactor.Action.addWord($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        buttonClear.rx.tap
            .map { Reactor.Action.inputSearchText("") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.searchText }
            .distinctUntilChanged()
            .bind(to: textFieldSearch.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.searchText }
            .map { $0.isEmpty }
            .distinctUntilChanged()
            .bind(to: buttonClear.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { $0.words }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        reactor.state.map { $0.shouldShowResults }
            .distinctUntilChanged()
            .filter { $0 }
            .withLatestFrom(reactor.state)
            .map { $0.searchText }
            .subscribeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in self?.textFieldSearch.resignFirstResponder() })
            .subscribe(onNext: { [weak self] keyword in
                guard let self = self else { return }
                let listViewController = ResultViewController(provider: self.provider, keyword: keyword)
                self.navigationController?.pushViewController(listViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension SearchViewController {
    private func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(44)
        }
        navigationBar.addSubview(textFieldSearch)
        textFieldSearch.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(53)
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(30)
        }
        imageViewSearch.snp.makeConstraints {
            $0.width.equalTo(40)
        }
        buttonClear.snp.makeConstraints {
            $0.width.equalTo(40)
        }
        let viewBackground = UIView().then {
            $0.backgroundColor = Color.navigationBackground
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
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeue(Reusable.searchHeader) {
            header.labelTitle.text = dataSource.sectionModels[section].header
            if let reactor = reactor {
                header.buttonDelete.rx.tap
                    .map { Reactor.Action.removeAllWords }
                    .bind(to: reactor.action)
                    .disposed(by: header.disposeBag)
            }
            return header
        }
        return nil
    }
}
