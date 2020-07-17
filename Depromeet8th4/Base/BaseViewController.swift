//
//  BaseViewController.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/07.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    var disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private(set) var didSetupConstraints = false

    override func viewDidLoad() {
        self.view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    func setupConstraints() {

    }

}
