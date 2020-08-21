//
//  MyPageReactor.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/13.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation
import ReactorKit

final class MyPageReactor: Reactor {
    let provider: ServiceProviderType

    init(provider: ServiceProviderType) {
        self.provider = provider
    }
    // MARK: - Reactor
    var initialState = State()

    struct State {
        var name: String = "노은종"
        let menus: [Menu] = [.invite, .notice, .customer, .setting]
    }
    enum Action {
        case refresh
    }
    enum Mutation {
        case setUser(UserEntity)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return provider.networkService.request(.user, type: UserEntity.self)
                .asObservable()
                .map { Mutation.setUser($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setUser(let user):
            state.name = user.name
        }
        return state
    }
}
