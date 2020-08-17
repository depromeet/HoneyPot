//
//  UserDefaultsKey.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/02.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation

struct UserDefaultsKey<T> {
    typealias Key<T> = UserDefaultsKey<T>
    let key: String
}

extension UserDefaultsKey: ExpressibleByStringLiteral {
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(key: value)
    }

    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(key: value)
    }

    public init(stringLiteral value: StringLiteralType) {
        self.init(key: value)
    }
}
