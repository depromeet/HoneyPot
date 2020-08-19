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
    case post(Int)
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
        case .post(let id):
            return .get("/posts/\(id)")
        }
    }

    var parameters: Parameters? {
        switch self {
        case .user:
            return nil
        case .post:
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
