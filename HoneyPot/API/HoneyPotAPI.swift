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
        case .post(let id):
            return .get("/posts/\(id)")
        case .postLike(let id):
            return .post("/posts/\(id)/like")
        case .participate(let id):
            return .post("/posts/\(id)/participate")
        case .comments(let id, _):
            return .get("/posts/\(id)/comments/detail")
        case .commentAdd:
            return .post("/comments")
        case .commentRemove(let id):
            return .delete("/comments/\(id)")
        case .commentLike(let id):
            return .post("/comments/\(id)/like")
        case .subcomments(let id):
            return .get("/comments/\(id)")
        }
    }

    var parameters: Parameters? {
        switch self {
        case .user:
            return nil
        case .posts(let keyword, let category, let sort, let index):
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
        case .comments(_, let index):
            let values: [String: Any] = [
                "page": index,
                "size": 10
            ]
            return .init(encoding: URLEncoding(), values: values)
        case .commentAdd(let postID, let commentID, let userID, let content):
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
