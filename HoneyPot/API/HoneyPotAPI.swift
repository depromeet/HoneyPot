//
//  HoneyPotAPI.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/07/16.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation
import Moya
import MoyaSugar

enum HoneyPotAPI {
    case user
    case posts(String, String, String, Int)
    case post(Int)
    case postLike(Int)
    case participate(Int)
    case comments(Int, Int)
    case commentAdd(Int, Int?, String, String)
    case commentRemove(Int)
    case commentLike(Int)
    case subcomments(Int)
}

extension HoneyPotAPI: SugarTargetType {
    var baseURL: URL {
        let string = "http://15.165.44.203:31923/api"
        return URL(string: string)!
    }

    var route: Route {
        switch self {
        case .user:
            return .get("/users/info")
        case .posts:
            return .get("/posts")
        case let .post(id):
            return .get("/posts/\(id)")
        case let .postLike(id):
            return .post("/posts/\(id)/like")
        case let .participate(id):
            return .post("/posts/\(id)/participate")
        case let .comments(id, _):
            return .get("/posts/\(id)/comments/detail")
        case .commentAdd:
            return .post("/comments")
        case let .commentRemove(id):
            return .delete("/comments/\(id)")
        case let .commentLike(id):
            return .post("/comments/\(id)/like")
        case let .subcomments(id):
            return .get("/comments/\(id)")
        }
    }

    var parameters: Parameters? {
        switch self {
        case .user:
            return nil
        case let .posts(keyword, category, sort, index):
            let values: [String: Any] = [
                "keyword": keyword,
                "category": category,
                "sortOption": sort,
                "page": index,
                "size": 10
            ]
            return .init(encoding: URLEncoding(), values: values)
        case .post:
            return nil
        case .postLike:
            return nil
        case .participate:
            return nil
        case let .comments(_, index):
            let values: [String: Any] = [
                "page": index,
                "size": 10
            ]
            return .init(encoding: URLEncoding(), values: values)
        case let .commentAdd(postID, commentID, userID, content):
            var values: [String: Any] = [
                "postId": postID,
                "userId": userID,
                "content": content
            ]
            if let commentID = commentID {
                values["commentId"] = commentID
            }
            return .init(encoding: JSONEncoding(), values: values)
        case .commentRemove:
            return nil
        case .commentLike:
            return nil
        case .subcomments:
            return nil
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }

    var sampleData: Data {
        return Data()
    }
}
