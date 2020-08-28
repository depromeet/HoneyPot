//
//  MainVC.swift
//  Depromeet8th4
//
//  Created by 최은지 on 2020/08/06.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Then
import UIKit

class MainViewController: BaseViewController, CustomMenuBarDelegate {
    let menu = ["전체", "살림", "패션", "뷰티", "푸드", "가전", "스포츠", "잡화"]

    let pageCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: collectionViewLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    let customMenuBar = CustomMenuBar()

    private enum Color {
        static let navigationBackground = 0xFFD136.color
    }

    lazy var navigationBar = NavigationBar(
        rightViews: [buttonSearch, buttonAccount]
    ).then {
        $0.backgroundColor = .clear
    }

    let buttonSearch = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_search_w24h24"), for: .normal)
    }

    let buttonAccount = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_my_w24h24"), for: .normal)
    }

    func customMenuBar(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupNavigationBar()
        setupCustomTabBar()
        setupPageCollectionView()
    }

    private func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(44)
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

    func setupCustomTabBar() {
        view.addSubview(customMenuBar)
        customMenuBar.delegate = self
        customMenuBar.translatesAutoresizingMaskIntoConstraints = false
        customMenuBar.indicatorViewWidthConstraint.constant = view.frame.width / 8
        customMenuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customMenuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customMenuBar.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        customMenuBar.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }

    func setupPageCollectionView() {
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        pageCollectionView.backgroundColor = .gray
        pageCollectionView.showsHorizontalScrollIndicator = false
        pageCollectionView.isPagingEnabled = true
        pageCollectionView.register(UINib(nibName: PageCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PageCell.reusableIdentifier)
        view.addSubview(pageCollectionView)
        pageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pageCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pageCollectionView.topAnchor.constraint(equalTo: customMenuBar.bottomAnchor).isActive = true
    }

    override func setupBindings() {
        buttonSearch.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let viewController = SearchViewController(reactor: .init(provider: self.provider))
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)

        buttonAccount.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let viewController = MyPageViewController(reactor: .init(provider: self.provider))
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return menu.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.reusableIdentifier, for: indexPath) as! PageCell
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customMenuBar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 8
    }

    func scrollViewWillEndDragging(_: UIScrollView, withVelocity _: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        customMenuBar.customTabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: pageCollectionView.frame.width, height: pageCollectionView.frame.height)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }
}
