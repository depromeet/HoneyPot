//
//  PagerBar.swift
//  PagerTabExample
//
//  Created by Soso on 2020/07/27.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PagerBar: UIView {
    private lazy var scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = true
    }
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 22
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = .init(top: 0, leading: 27, bottom: 0, trailing: 27)
    }
    private let viewIndicator = UIView().then {
        $0.backgroundColor = 0x323232.color
        $0.layer.cornerRadius = 3
    }

    var currentIndex: Int = 0 {
        didSet {
            guard currentIndex < stackView.arrangedSubviews.count else { return }
            let view = stackView.arrangedSubviews[currentIndex]

            let rect = view.frame.insetBy(dx: -stackView.spacing - 5, dy: 0)
            scrollView.scrollRectToVisible(rect, animated: true)

            var frame = stackView.convert(view.frame, to: scrollView)
            frame.origin.x -= 8
            frame.size.width += 16
            frame.origin.y = bounds.height - 3
            frame.size.height = 6
            UIView.animate(withDuration: 0.3) {
                self.viewIndicator.frame = frame
            }
        }
    }

    var spacing: CGFloat {
        get {
            return stackView.spacing
        }
        set {
            stackView.spacing = newValue
        }
    }

    init(subviews: [UIView] = []) {
        super.init(frame: .zero)

        setupViews(subviews: subviews)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        UIView.setAnimationsEnabled(false)
        let index = currentIndex
        currentIndex = index
        UIView.setAnimationsEnabled(true)
    }

    func setupViews(subviews: [UIView]) {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        scrollView.addSubview(viewIndicator)

        subviews.forEach { view in
            stackView.addArrangedSubview(view)
        }
        layoutIfNeeded()
    }
}

extension Reactive where Base: PagerBar {
    var currentIndex: Binder<Int> {
        return Binder(base) { pager, currentIndex in
            pager.currentIndex = currentIndex
        }
    }
}
