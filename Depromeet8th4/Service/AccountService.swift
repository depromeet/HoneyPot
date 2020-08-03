//
//  AccountService.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/02.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension UserDefaultsKey {
    static var userID: Key<String> { return "userID" }
}

protocol AccountServiceType {
    var userID: String { get }
    func getUserID() -> Observable<String>
    func setUserID(newUserID: String) -> Observable<String>
}

class AccountService: BaseService, AccountServiceType {
    var userID: String {
        provider.userDefaultsService.value(forKey: .userID) ?? "1"
    }

    func getUserID() -> Observable<String> {
        return Observable
            .just(provider.userDefaultsService.value(forKey: .userID) ?? "1")
    }

    func setUserID(newUserID: String) -> Observable<String> {
        provider.userDefaultsService.set(value: newUserID, forKey: .userID)
        return .just(newUserID)
    }
}
