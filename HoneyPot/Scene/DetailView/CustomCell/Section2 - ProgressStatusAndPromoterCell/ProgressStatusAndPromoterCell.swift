//
//  ProgressStatusAndPromoterCell.swift
//  Depromeet8th4
//
//  Created by Yeojaeng on 2020/08/03.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class ProgressStatusAndPromoterCell: UITableViewCell {
    @IBOutlet weak var honeyPotIcon: UIImageView!
    @IBOutlet weak var destDiscountPercent: UILabel!
    @IBOutlet weak var insufficientPersonCount: UILabel!
    @IBOutlet weak var discountGuideButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var promoterView: UIView!
    @IBOutlet weak var participantCount: UILabel!
    @IBOutlet weak var deadlineTimeCount: UILabel!
    @IBOutlet weak var promoterThumbnail: UIImageView!
    @IBOutlet weak var promoterName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDiscountGuideButton()
        setupPromoterView()
    }
    func setupDiscountGuideButton() {
        discountGuideButton.backgroundColor = 0xF8F8F8.color
        discountGuideButton.layer.cornerRadius = 5
    }
    func setupPromoterView() {
        promoterView.layer.cornerRadius = 3
    }
    @IBAction func tappedDiscountGuideButton(_ sender: UIButton) {
        let customAlert: UIViewController = CustomAlertView()
        customAlert.modalPresentationStyle = .overCurrentContext
        self.window?.rootViewController?.present(customAlert, animated: false, completion: nil)
    }
}
