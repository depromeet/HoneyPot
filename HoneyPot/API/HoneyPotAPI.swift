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
    case posts(String, String, String)
    case post(Int)
    case postLike(Int)
    case commentAdd(Int, Int?, String, String)
    case commentRemove(Int)
    case commentLike(Int)
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
        case .commentAdd:
            return .post("/comments")
        case .commentRemove(let id):
            return .delete("/comments/\(id)")
        case .commentLike(let id):
            return .post("/comments/\(id)/like")
        }
    }

    var parameters: Parameters? {
        switch self {
        case .user:
            return nil
        case .posts(let keyword, let category, let sort):
            let values: [String: Any] = [
                "keyword": keyword,
                "category": category,
                "sortOption": sort
            ]
            return .init(encoding: URLEncoding(), values: values)
        case .post:
            return nil
        case .postLike:
            return nil
        case .commentAdd(let postID, let commentID, let userID, let content):
            var values: [String: Any] = [
                "postId": postID,
                "userID": userID,
                "content": content
            ]
            if let commentID = commentID {
                values["commentID"] = commentID
            }
            return .init(encoding: JSONEncoding(), values: values)
        case .commentRemove:
            return nil
        case .commentLike:
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
