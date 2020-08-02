//
//  ServiceType.swift
//  Gagaebu
//
//  Created by Soso on 2020/06/13.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation

protocol ServiceProviderType: class {
    var networkService: NetworkServiceType { get }
    var userDefaultsService: UserDefaultsServiceType { get }
    var accountService: AccountServiceType { get }
}

class ServiceProvider: ServiceProviderType {
    lazy var networkService: NetworkServiceType = NetworkService(provider: self)
    lazy var userDefaultsService: UserDefaultsServiceType = UserDefaultsService(provider: self)
    lazy var accountService: AccountServiceType = AccountService(provider: self)
}
