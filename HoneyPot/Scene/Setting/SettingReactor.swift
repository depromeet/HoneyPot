//
//  SettingReactor.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/02.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation
import ReactorKit

final class SettingReactor: Reactor {
    let provider: ServiceProviderType

    init(provider: ServiceProviderType) {
        self.provider = provider
    }

    // MARK: - Reactor

    var initialState = State()

    struct State {
        var userID: String = ""
    }

    enum Action {
        case getUserID
        case setUserID(String)
    }

    enum Mutation {
        case setUserID(String)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getUserID:
            return provider.accountService
                .getUserID()
                .map { Mutation.setUserID($0) }
        case let .setUserID(userID):
            return provider.accountService
                .setUserID(newUserID: userID)
                .map { Mutation.setUserID($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setUserID(newUserID):
            state.userID = newUserID
        }
        return state
    }

    func transform(action: Observable<Action>) -> Observable<Action> {
        return action
            .share()
            .startWith(Action.getUserID)
    }
}
