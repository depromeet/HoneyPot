//
//  ItemAPI.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/07/16.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation
import Moya
import MoyaSugar

enum ItemAPI {
    case fetchItems(String)
}

extension ItemAPI: SugarTargetType {
    var baseURL: URL {
        let string = "https://www.google.com"
        return URL(string: string)!
    }

    var route: Route {
        switch self {
        case .fetchItems(let text):
            return .get(text)
        }
    }

    var parameters: Parameters? {
        switch self {
        case .fetchItems:
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
