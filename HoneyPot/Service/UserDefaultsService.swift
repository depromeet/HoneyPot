//
//  UserDefaultsService.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/02.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation

protocol UserDefaultsServiceType {
    func value<T>(forKey key: UserDefaultsKey<T>) -> T?
    func set<T>(value: T?, forKey key: UserDefaultsKey<T>)
}

final class UserDefaultsService: BaseService, UserDefaultsServiceType {
    private var defaults: UserDefaults {
        return UserDefaults.standard
    }

    func value<T>(forKey key: UserDefaultsKey<T>) -> T? {
        return self.defaults.value(forKey: key.key) as? T
    }

    func set<T>(value: T?, forKey key: UserDefaultsKey<T>) {
        self.defaults.set(value, forKey: key.key)
        self.defaults.synchronize()
    }
}
