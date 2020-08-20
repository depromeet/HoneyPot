//
//  Pageable.swift
//  HoneyPot
//
//  Created by Soso on 2020/08/20.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation

struct PageableList<T: Decodable>: Decodable {
    let totalPages: Int
    let totalElements: Int
    let pageable: Pageable
    let sort: Sort
    let numberOfElements: Int
    let first: Bool
    let last: Bool
    let size: Int
    let content: [T]
    let number: Int
    let empty: Bool
}

struct Pageable: Decodable {
    let pageNumber: Int
    let pageSize: Int
    let sort: Sort
    let paged: Bool
    let unpaged: Bool
    let offset: Int
}

struct Sort: Decodable {
    let sorted: Bool
    let unsorted: Bool
    let empty: Bool
}
