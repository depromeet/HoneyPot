//
//  BaseViewController.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/07.
//  Copyright © 2020 Soso. All rights reserved.
//

import RxSwift
import UIKit

class BaseViewController: UIViewController {
    let provider: ServiceProviderType
    var disposeBag = DisposeBag()

    /// Service Provider DI 전용 생성자
    init(provider: ServiceProviderType) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private(set) var didSetupConstraints = false

    override func viewDidLoad() {
        view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
        if !didSetupConstraints {
            didSetupConstraints = true
            setupConstraints()
            setupBindings()
        }
        super.updateViewConstraints()
    }

    func setupConstraints() {}

    func setupBindings() {}
}
