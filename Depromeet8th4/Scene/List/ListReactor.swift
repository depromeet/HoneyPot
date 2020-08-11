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
        let sortList: [SortKind] = SortKind.allCases
        var sortIndex: Int = 0
        var sortTitle: String = SortKind.suggestion.title
        var items: [String] = []
    }
    enum Action {
        case refresh
        case selectSortIndex(Int)
    }
    enum Mutation {
        case setItems([String])
        case setSortTitle(Int)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return requestItems()
                .map { Mutation.setItems($0) }
        case .selectSortIndex(let index):
            return Observable.concat(
                .just(Mutation.setSortTitle(index)),
                requestItems()
                    .map { Mutation.setItems($0) }
            )
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setItems(let items):
            state.items = items
        case .setSortTitle(let index):
            state.sortTitle = state.sortList[index].title
        }
        return state
    }

    private func requestItems() -> Observable<[String]> {
        return .just(["1", "2", "3", "4", "5", "6", ""])
    }
}
