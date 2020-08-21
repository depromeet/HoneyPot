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
        $0.image = nil
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = UIColor(named: "color_unselect")
        $0.layer.cornerRadius = 5
    }

    let productNameLabel = UILabel().then {
        $0.text = "테이블팬 C820 (3 Colors)"
        $0.font = UIFont(name: "GodoB", size: 20)!
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let productSortLabel = UILabel().then {
        $0.text = "가전 | 플러스마이너스제로"
        $0.font = UIFont.systemFont(ofSize: 16)
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
        $0.textColor = UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let timeImageView = UIImageView().then {
        $0.image = UIImage(named: "icon_time_w24h24")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let timeLabel = UILabel().then {
        $0.textColor = UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1)
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

    let leaveLabel = UILabel().then {
        $0.textColor = UIColor(named: "color_unselect")
        $0.font = UIFont.systemFont(ofSize: 12, weight: .light)
        $0.text = "40% 할인까지 24명!"
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let commentView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let commentImageView = UIImageView().then {
        $0.image = UIImage(named: "icon_bubble_light_w16h16")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let commentLabel = UILabel().then {
        $0.text = "100"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.textColor = UIColor(named: "color_unselect")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let favoriteView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let favoriteImageView = UIImageView().then {
        $0.image = UIImage(named: "icon_heart_w16h16")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let favoriteLabel = UILabel().then {
        $0.text = "100"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.textColor = UIColor(named: "color_unselect")
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
        productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 17).isActive = true
        productNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18).isActive = true

        addSubview(productSortLabel)
        productSortLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8).isActive = true
        productSortLabel.leadingAnchor.constraint(lessThanOrEqualTo: self.leadingAnchor, constant: 18).isActive = true

        addSubview(productSlider)
        productSlider.topAnchor.constraint(equalTo: productSortLabel.bottomAnchor, constant: 10).isActive = true
        productSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18).isActive = true
        productSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18).isActive = true

        addSubview(myImageView)
        myImageView.topAnchor.constraint(equalTo: productSlider.bottomAnchor, constant: 11).isActive = true
        myImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18).isActive = true

        let join1 = NSAttributedString(string: "426명 ", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .bold)])
        let join2 = NSAttributedString(string: "참여중", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        let joinAttrString = NSMutableAttributedString()
        joinAttrString.append(join1)
        joinAttrString.append(join2)
        joinLabel.attributedText = joinAttrString

        addSubview(joinLabel)
        joinLabel.centerYAnchor.constraint(equalTo: myImageView.centerYAnchor).isActive = true
        joinLabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 5).isActive = true

        addSubview(timeImageView)
        timeImageView.topAnchor.constraint(equalTo: myImageView.bottomAnchor, constant: 4).isActive = true
        timeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18).isActive = true

        let time1 = NSAttributedString(string: "4일 21시간 ", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .bold)])
        let time2 = NSAttributedString(string: "남음", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        let timeAttrString = NSMutableAttributedString()
        timeAttrString.append(time1)
        timeAttrString.append(time2)
        timeLabel.attributedText = timeAttrString

        addSubview(timeLabel)
        timeLabel.centerYAnchor.constraint(equalTo: timeImageView.centerYAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: timeImageView.trailingAnchor, constant: 5).isActive = true

        let num1 = NSAttributedString(string: "32,500", attributes: [.font: UIFont.systemFont(ofSize: 25, weight: .bold)])
        let num2 = NSAttributedString(string: " 원", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .light)])
        let numAttrString = NSMutableAttributedString()
        numAttrString.append(num1)
        numAttrString.append(num2)
        numberLabel.attributedText = numAttrString

        addSubview(numberLabel)
        numberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18).isActive = true
        numberLabel.topAnchor.constraint(equalTo: productSlider.bottomAnchor, constant: 8).isActive = true

        addSubview(percentLabel)
        percentLabel.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor).isActive = true
        percentLabel.trailingAnchor.constraint(equalTo: numberLabel.leadingAnchor, constant: -10).isActive = true

        addSubview(leaveLabel)
        leaveLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18).isActive = true
        leaveLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 3).isActive = true

        addSubview(commentView)
        commentView.widthAnchor.constraint(equalToConstant: 51).isActive = true
        commentView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        commentView.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -15).isActive = true
        commentView.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 15).isActive = true

        addSubview(commentLabel)
        commentLabel.centerYAnchor.constraint(equalTo: commentView.centerYAnchor).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: commentView.trailingAnchor, constant: -5).isActive = true

        addSubview(commentImageView)
        commentImageView.centerYAnchor.constraint(equalTo: commentView.centerYAnchor).isActive = true
        commentImageView.trailingAnchor.constraint(equalTo: commentLabel.leadingAnchor, constant: -2).isActive = true

        addSubview(favoriteView)
        favoriteView.widthAnchor.constraint(equalToConstant: 51).isActive = true
        favoriteView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        favoriteView.centerYAnchor.constraint(equalTo: commentView.centerYAnchor).isActive = true
        favoriteView.trailingAnchor.constraint(equalTo: commentView.leadingAnchor, constant: -5).isActive = true

        addSubview(favoriteLabel)
        favoriteLabel.centerYAnchor.constraint(equalTo: favoriteView.centerYAnchor).isActive = true
        favoriteLabel.trailingAnchor.constraint(equalTo: favoriteView.trailingAnchor, constant: -5).isActive = true

        addSubview(favoriteImageView)
        favoriteImageView.centerYAnchor.constraint(equalTo: favoriteView.centerYAnchor).isActive = true
        favoriteImageView.trailingAnchor.constraint(equalTo: favoriteLabel.leadingAnchor, constant: -2).isActive = true
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
