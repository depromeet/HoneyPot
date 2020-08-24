//
//  CommentSection.swift
//  Development
//
//  Created by Soso on 2020/08/23.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import RxDataSources

struct CommentSection {
    var id: Int
    var items: [CommentSectionItem]
}

extension CommentSection: SectionModelType {
    init(original: CommentSection, items: [CommentSectionItem]) {
        self = original
        self.items = items
    }
}

extension CommentSection: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.items == rhs.items
    }
}

enum CommentSectionItem {
    case comment(Comment)
    case subcomment(Comment)

    var item: Comment {
        get {
            switch self {
            case .comment(let comment):
                return comment
            case .subcomment(let comment):
                return comment
            }
        }
        set {
            switch self {
            case .comment:
                self = .comment(newValue)
            case .subcomment:
                self = .subcomment(newValue)
            }
        }
    }
}

extension CommentSectionItem: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.comment(let first), .comment(let second)):
            return first == second
        case (.subcomment(let first), .subcomment(let second)):
            return first == second
        default:
            return false
        }
    }
}
