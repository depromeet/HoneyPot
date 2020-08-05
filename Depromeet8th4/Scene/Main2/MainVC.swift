//
//  MainVC.swift
//  Depromeet8th4
//
//  Created by 최은지 on 2020/08/06.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import Then

class MainVC: BaseViewController, CustomMenuBarDelegate {
    
    let pageCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: collectionViewLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var customMenuBar = CustomMenuBar()
    
    func customMenuBar(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.setNavigation()
        
        self.setupCustomTabBar()
        self.setupPageCollectionView()
    }
    
    func setNavigation(){
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "color_main")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        
        let logoButton = UIButton().then {
            $0.setImage(UIImage(named: "image_logo_w79h22"), for: .normal)
        }
        
        let searchButton = UIButton().then {
            $0.setImage(UIImage(named: "icon_search_w24h24"), for: .normal)
        }
        
        let mypageButton = UIButton().then {
            $0.setImage(UIImage(named: "icon_my_w24h24"), for: .normal)
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoButton)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: searchButton), UIBarButtonItem(customView: mypageButton)]
    }
    
    func setupCustomTabBar(){
        self.view.addSubview(customMenuBar)
        customMenuBar.delegate = self
        customMenuBar.translatesAutoresizingMaskIntoConstraints = false
        customMenuBar.indicatorViewWidthConstraint.constant = self.view.frame.width / 4
        customMenuBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        customMenuBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        customMenuBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        customMenuBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setupPageCollectionView(){
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        pageCollectionView.backgroundColor = .gray
        pageCollectionView.showsHorizontalScrollIndicator = false
        pageCollectionView.isPagingEnabled = true
        pageCollectionView.register(UINib(nibName: PageCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PageCell.reusableIdentifier)
        self.view.addSubview(pageCollectionView)
        pageCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pageCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pageCollectionView.topAnchor.constraint(equalTo: self.customMenuBar.bottomAnchor).isActive = true
    }
    
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.reusableIdentifier, for: indexPath) as! PageCell
        cell.label.text = "\(indexPath.row)번째 view"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customMenuBar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 4
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        customMenuBar.customTabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pageCollectionView.frame.width, height: pageCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
