//
//  ProductCell.swift
//  Depromeet8th4
//
//  Created by 최은지 on 2020/08/06.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import Then

class ProductCell: UITableViewCell {

    let productImageView = UIImageView().then {
        $0.image = UIImage(named: "sampleImage")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
    }

    let productNameLabel = UILabel().then {
        $0.text = "테이블팬 C820 (3 Colors)"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let productSortLabel = UILabel().then {
        $0.text = "가전 | 플러스마이너스제로"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let productSlider = ProductSlider().then {
        $0.tintColor = UIColor(named: "color_main")
        $0.minimumValue = 0
        $0.maximumValue = 100
        $0.setValue(70, animated: false)
        $0.setThumbImage(UIImage(), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let myImageView = UIImageView().then {
        $0.image = UIImage(named: "icon_my_w24h24-1")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let joinLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let timeImageView = UIImageView().then {
        $0.image = UIImage(named: "icon_time_w24h24")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let timeLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let numberLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let percentLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .red
        $0.text = "35%"
        $0.font = UIFont.systemFont(ofSize: 25, weight: .bold)
    }

    let chatView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let chatLabel = UILabel().then {
        $0.text = "20"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        $0.textAlignment = .center
        $0.textColor = .darkGray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let chatImageView = UIImageView().then {
        $0.image = UIImage(named: "icon_chat_w24h24")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let favoriteView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let favoriteLabel = UILabel().then {
        $0.text = "100"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        $0.textAlignment = .center
        $0.textColor = .darkGray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let favoriteImageView = UIImageView().then {
        $0.image = UIImage(named: "icon_favorite_w24h24")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        addSubview(productImageView)
        productImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        productImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18).isActive = true
        productImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18).isActive = true
        productImageView.heightAnchor.constraint(equalToConstant: 222).isActive = true
        addSubview(productNameLabel)
        productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 30).isActive = true
        productNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18).isActive = true

        addSubview(productSortLabel)
        productSortLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 10).isActive = true
        productSortLabel.leadingAnchor.constraint(lessThanOrEqualTo: self.leadingAnchor, constant: 18).isActive = true

        addSubview(productSlider)
        productSlider.topAnchor.constraint(equalTo: productSortLabel.bottomAnchor, constant: 10).isActive = true
        productSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18).isActive = true
        productSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18).isActive = true

        addSubview(myImageView)
        myImageView.topAnchor.constraint(equalTo: productSlider.bottomAnchor, constant: 10).isActive = true
        myImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18).isActive = true

        let join1 = NSAttributedString(string: "426명 ", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .bold)])
        let join2 = NSAttributedString(string: "참여중", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        let joinAttrString = NSMutableAttributedString()
        joinAttrString.append(join1)
        joinAttrString.append(join2)
        joinLabel.attributedText = joinAttrString

        addSubview(joinLabel)
        joinLabel.topAnchor.constraint(equalTo: productSlider.bottomAnchor, constant: 10).isActive = true
        joinLabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 10).isActive = true

        addSubview(timeImageView)
        timeImageView.topAnchor.constraint(equalTo: myImageView.bottomAnchor, constant: 10).isActive = true
        timeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18).isActive = true

        let time1 = NSAttributedString(string: "4일 21시간 ", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .bold)])
        let time2 = NSAttributedString(string: "남음", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        let timeAttrString = NSMutableAttributedString()
        timeAttrString.append(time1)
        timeAttrString.append(time2)
        timeLabel.attributedText = timeAttrString

        addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: myImageView.bottomAnchor, constant: 10).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: timeImageView.trailingAnchor, constant: 10).isActive = true

        let num1 = NSAttributedString(string: "32,500", attributes: [.font: UIFont.systemFont(ofSize: 25, weight: .bold)])
        let num2 = NSAttributedString(string: " 원", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        let numAttrString = NSMutableAttributedString()
        numAttrString.append(num1)
        numAttrString.append(num2)
        numberLabel.attributedText = numAttrString

        addSubview(numberLabel)
        numberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18).isActive = true
        numberLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true

        addSubview(percentLabel)
        percentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true
        percentLabel.trailingAnchor.constraint(equalTo: numberLabel.leadingAnchor, constant: -10).isActive = true

        addSubview(chatView)
        chatView.topAnchor.constraint(equalTo: self.productImageView.topAnchor, constant: 10).isActive = true
        chatView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        chatView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        chatView.trailingAnchor.constraint(equalTo: self.productImageView.trailingAnchor, constant: -20).isActive = true

        addSubview(chatLabel)
        chatLabel.centerYAnchor.constraint(equalTo: self.chatView.centerYAnchor).isActive = true
        chatLabel.trailingAnchor.constraint(equalTo: chatView.trailingAnchor, constant: -10).isActive = true

        addSubview(chatImageView)
        chatImageView.centerYAnchor.constraint(equalTo: chatView.centerYAnchor).isActive = true
        chatImageView.trailingAnchor.constraint(equalTo: chatLabel.leadingAnchor, constant: -5).isActive = true

        addSubview(favoriteView)
        favoriteView.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 10).isActive = true
        favoriteView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        favoriteView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        favoriteView.trailingAnchor.constraint(equalTo: chatView.leadingAnchor, constant: -10).isActive = true

        addSubview(favoriteLabel)
        favoriteLabel.centerYAnchor.constraint(equalTo: favoriteView.centerYAnchor).isActive = true
        favoriteLabel.trailingAnchor.constraint(equalTo: favoriteView.trailingAnchor, constant: -5).isActive = true

        addSubview(favoriteImageView)
        favoriteImageView.centerYAnchor.constraint(equalTo: favoriteView.centerYAnchor).isActive = true
        favoriteImageView.trailingAnchor.constraint(equalTo: favoriteLabel.leadingAnchor, constant: -5).isActive = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

class ProductSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 5
        return newBounds
    }
}
