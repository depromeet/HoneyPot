//
//  ItemEntity.swift
//  HoneyPot
//
//  Created by Soso on 2020/08/20.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation

struct ItemEntity: Decodable {
    let id: Int
    let thumbnail: String
    let numberOfWish: Int
    let numberOfComment: Int
    let title: String
    let category: String
    let sellerName: String
    let price: Int
    let nowDiscount: DiscountEntity?
    let nextDiscount: DiscountEntity?
    let participants: Int
    let numberOfGoal: Int
    let deadline: String
}
