//
//  CustomAlertView.swift
//  Development
//
//  Created by Yeojaeng on 2020/08/22.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class CustomAlertView: UIViewController {
    @IBOutlet weak var customAlertView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupAlertView() {
        customAlertView.layer.cornerRadius = 10
    }

    @IBAction func tappedCloseButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
