//
//  ListReactor.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/10.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation
import ReactorKit

final class ListReactor: Reactor {
    let provider: ServiceProviderType

    init(provider: ServiceProviderType, keyword: String) {
        self.provider = provider
        self.initialState = State(keyword: keyword)
    }

    // MARK: - Reactor
    var initialState: State

    struct State {
        let keyword: String
        var sort: String = ""
        var items: [String] = []
    }
    enum Action {
        case refresh
    }
    enum Mutation {
        case setItems([String])
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return requestItems(sort: currentState.sort)
                .map { Mutation.setItems($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setItems(let items):
            state.items = items
        }
        return state
    }

    private func requestItems(sort: String) -> Observable<[String]> {
        return .just(["1", "2", "3", "4", "5", "6", ""])
    }
}
