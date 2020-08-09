//
//  FlagService.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/09.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation

extension UserDefaultsKey {
    static var hasClosedSharePopup: Key<Bool> {
        return "hasClosedSharePopupFlag"
    }
}

protocol FlagServiceType {
    func value(forKey key: UserDefaultsKey<Bool>) -> Bool
    func set(value: Bool, forKey key: UserDefaultsKey<Bool>)
}

final class FlagService: BaseService, FlagServiceType {
    func value(forKey key: UserDefaultsKey<Bool>) -> Bool {
        return provider.userDefaultsService.value(forKey: key) ?? false
    }

    func set(value: Bool, forKey key: UserDefaultsKey<Bool>) {
        provider.userDefaultsService.set(value: value, forKey: key)
    }
}
