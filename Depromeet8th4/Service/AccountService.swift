//
//  AccountService.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/02.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation

extension UserDefaultsKey {
    static var userID: Key<String> { return "userID" }
}

protocol AccountServiceType {
    var userID: String { get set }
}

class AccountService: BaseService, AccountServiceType {
    override init(provider: ServiceProviderType) {
        if let userID = provider.userDefaultsService.value(forKey: .userID) {
            self.userID = userID
        } else {
            self.userID = "1"
        }
        super.init(provider: provider)
    }

    var userID: String {
        didSet {
            NSLog("didSet userID to: %@", userID)
            provider.userDefaultsService.set(value: userID, forKey: .userID)
        }
    }
}
