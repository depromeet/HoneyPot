//
//  SellerEntity.swift
//  HoneyPot
//
//  Created by Soso on 2020/08/19.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation

struct SellerEntity: Decodable {
    let sellerId: Int
    let name: String
    let numberOfReview: Int
}
