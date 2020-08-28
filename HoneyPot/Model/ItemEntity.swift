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

    var deadlineDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: deadline)
    }

    var isClosed: Bool {
        let current = Date()
        if let date = deadlineDate {
            return current > date
        } else {
            return false
        }
    }
}

extension ItemEntity: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
            && lhs.numberOfWish == rhs.numberOfWish
            && lhs.numberOfComment == rhs.numberOfComment
            && lhs.participants == rhs.participants
    }
}
