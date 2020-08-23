//
//  CommentEntity.swift
//  HoneyPot
//
//  Created by Soso on 2020/08/19.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation

struct CommentEntity: Decodable {
    let commentId: Int
    let comment: String
    let author: AuthorEntity
    let numberOfWish: Int
    let numberOfSubComments: Int
    let createdDate: String
    let comments: [CommentEntity]
    var liked: Bool
}

extension CommentEntity: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.commentId == rhs.commentId
    }
}
