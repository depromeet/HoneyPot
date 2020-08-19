//
//  PostEntity.swift
//  Development
//
//  Created by Soso on 2020/08/19.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation

struct PostEntity: Decodable {
    let postId: Int
    let bannerUrl: String
    let contentUrl: String
    let description: PostDescriptionEntity
    let seller: SellerEntity
    let comments: [CommentEntity]
}
