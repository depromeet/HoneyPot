//
//  SearchReactor.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/08.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation
import ReactorKit

final class SearchReactor: Reactor {
    let provider: ServiceProviderType

    init(provider: ServiceProviderType) {
        self.provider = provider
    }
    // MARK: - Reactor
    var initialState = State()

    struct State {
        var searchText: String = ""
    }
    enum Action {
        case inputSearchText(String)
    }
    enum Mutation {
        case setSearchText(String)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .inputSearchText(let text):
            return .just(Mutation.setSearchText(text))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setSearchText(let text):
            state.searchText = text
        }
        return state
    }
}
