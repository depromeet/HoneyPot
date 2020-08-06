//
//  CustomMenuBar.swift
//  Depromeet8th4
//
//  Created by 최은지 on 2020/08/06.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import Then

protocol CustomMenuBarDelegate: class {
    func customMenuBar(scrollTo index: Int)
}

class CustomMenuBar: UIView {
    let menu = ["전체", "살림", "패션", "뷰티", "푸드", "가전", "스포츠", "잡화"]
    weak var delegate: CustomMenuBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupCustomTabBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var customTabBarCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var indicatorView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(named: "color_select")
    }
    
    var indicatorViewLeadingConstraint:NSLayoutConstraint!
    var indicatorViewWidthConstraint: NSLayoutConstraint!
    
    
    func setupCollectioView(){
        customTabBarCollectionView.delegate = self
        customTabBarCollectionView.dataSource = self
        customTabBarCollectionView.showsHorizontalScrollIndicator = false
        customTabBarCollectionView.register(UINib(nibName: CustomCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: CustomCell.reusableIdentifier)
        customTabBarCollectionView.isScrollEnabled = true
        
        let indexPath = IndexPath(item: 0, section: 0)
        customTabBarCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    
    func setupCustomTabBar(){
        setupCollectioView()
        self.addSubview(customTabBarCollectionView)
        customTabBarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        customTabBarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        customTabBarCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        customTabBarCollectionView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        self.addSubview(indicatorView)
        indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: self.frame.width/8)
        indicatorViewWidthConstraint.isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        indicatorViewLeadingConstraint.isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}

extension CustomMenuBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.reusableIdentifier, for: indexPath) as! CustomCell
        cell.tabLabel.text = menu[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width/8 , height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.customMenuBar(scrollTo: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCell else {return}
        cell.tabLabel.textColor = UIColor(named: "color_unselect")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
