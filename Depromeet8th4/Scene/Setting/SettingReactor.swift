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

    let service: ServiceProviderType

    init(service: ServiceProviderType) {
        self.service = service
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
            return service.accountService
                .getUserID()
                .map { Mutation.setUserID($0) }
        case .setUserID(let userID):
            return service.accountService
                .setUserID(newUserID: userID)
                .map { Mutation.setUserID($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setUserID(let newUserID):
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
