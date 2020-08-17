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
        case setName(String)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return requestUserInfo()
                .map(Mutation.setName)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setName(let name):
            state.name = name
        }
        return state
    }

    private func requestUserInfo() -> Observable<String> {
        return .just("노은종")
    }
}
