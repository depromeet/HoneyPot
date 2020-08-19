//
//  PostDescriptionEntity.swift
//  HoneyPot
//
//  Created by Soso on 2020/08/19.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation

struct PostDescriptionEntity: Decodable {
    let id: Int
    let title: String
    let category: String
    let price: Int
    let nowDiscount: DiscountEntity?
    let nextDiscount: DiscountEntity?
    let discounts: [DiscountEntity]
    let participants: Int
    let numberOfGoal: Int
    let deadline: String
}
