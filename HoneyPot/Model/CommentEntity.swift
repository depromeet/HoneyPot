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

struct Comment {
    let commentID: Int
    let comment: String
    let author: AuthorEntity
    var likeCount: Int
    var subcommentCount: Int
    let createdDate: Date?
    var comments: [Comment]
    var isLiked: Bool
    var isExpanded: Bool

    var canExpand: Bool {
        return !comments.isEmpty
    }

    var expandText: String {
        let number = max(subcommentCount - comments.count, 0)
        if number == 0 {
            if isExpanded {
                return "대댓글 접기"
            } else {
                return "대댓글 펼치기"
            }
        } else {
            return "이전 대댓글 \(number)개 더 보기"
        }
    }

    var dateText: String? {
        guard let date = createdDate else { return nil }
        let interval = Int(round(abs(date.timeIntervalSinceNow)))
        let minute = 60
        let hour = minute * 60
        let day = hour * 24

        let numberOfDaysLeft = interval / day
        let numberOfHoursLeft = interval % day / hour
        let numberOfMinutesLeft = interval % day % hour / minute

        if numberOfDaysLeft > 7 {
            let calendar = Calendar(identifier: .gregorian)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            return "\(month).\(day)"
        } else if numberOfDaysLeft > 0 {
            return "\(numberOfDaysLeft)일 전"
        } else if numberOfHoursLeft > 0 {
            return "\(numberOfHoursLeft)시간 전"
        } else if numberOfMinutesLeft > 0 {
            return "\(numberOfMinutesLeft)분 전"
        } else {
            return "방금 전"
        }
    }
}

extension Comment {
    init(entity: CommentEntity) {
        commentID = entity.commentId
        comment = entity.comment
        author = entity.author
        likeCount = entity.numberOfWish
        subcommentCount = entity.numberOfSubComments
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        createdDate = formatter.date(from: entity.createdDate)
        comments = entity.comments.map(Comment.init)
        isLiked = entity.liked
        isExpanded = true
    }
}

extension Comment: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.commentID == rhs.commentID
            && lhs.isLiked == rhs.isLiked
    }
}
