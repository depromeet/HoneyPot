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

    init(
        provider: ServiceProviderType,
        keyword: String = "",
        category: String = ""
    ) {
        self.provider = provider
        self.initialState = State(keyword: keyword, category: category)
    }

    // MARK: - Reactor
    var initialState: State

    struct State {
        let keyword: String
        var category: String
        let sortList: [SortKind] = SortKind.allCases
        var sortIndex: Int = 0
        var sortTitle: String = SortKind.suggestion.title
        var pageIndex: Int = 0
        var items: [ItemEntity] = []
        var isRefreshing = false
        var isLoading = false
    }
    enum Action {
        case refresh
        case load
        case selectSortIndex(Int)
    }
    enum Mutation {
        case setItems([ItemEntity])
        case appendItems([ItemEntity])
        case setSortTitle(Int)
        case setRefreshing(Bool)
        case setLoading(Bool)
        case setPageIndex(Int)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            let sort = currentState.sortList[currentState.sortIndex].rawValue
            return Observable.concat(
                refresh(sort: sort),
                .just(Mutation.setPageIndex(0))
            )
        case .load:
            guard !currentState.isLoading else { return .empty() }
            let index = currentState.pageIndex + 1
            return Observable.concat(
                load(index: index),
                .just(Mutation.setPageIndex(index))
            )
        case .selectSortIndex(let index):
            let sort = currentState.sortList[index].rawValue
            return Observable.concat(
                .just(Mutation.setSortTitle(index)),
                refresh(sort: sort)
            )
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setItems(let items):
            state.items = items
        case .appendItems(let items):
            state.items += items
        case .setSortTitle(let index):
            state.sortIndex = index
            state.sortTitle = state.sortList[index].title
        case .setRefreshing(let isRefreshing):
            state.isRefreshing = isRefreshing
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setPageIndex(let index):
            state.pageIndex = index
        }
        return state
    }

    private func refresh(
        category: String = "",
        sort: String = ""
    ) -> Observable<Mutation> {
        return Observable.concat(
            .just(Mutation.setRefreshing(true)),
            requestItems(category: category, sort: sort)
                .map({ Mutation.setItems($0) })
                .observeOn(MainScheduler.asyncInstance),
            .just(Mutation.setRefreshing(false))
        )
    }
    private func load(
        index: Int
    ) -> Observable<Mutation> {
        let category = currentState.category
        let sort = currentState.sortList[currentState.sortIndex].rawValue
        return Observable.concat(
            .just(Mutation.setLoading(true)),
            requestItems(category: category, sort: sort, index: index)
                .map({ Mutation.appendItems($0) })
                .observeOn(MainScheduler.asyncInstance),
            .just(Mutation.setLoading(false))
        )
    }
    private func requestItems(
        category: String,
        sort: String,
        index: Int = 0
    ) -> Observable<[ItemEntity]> {
        let keyword = currentState.keyword
        return provider.networkService
            .request(.posts(keyword, category, sort, index), type: PageableList<ItemEntity>.self)
            .map { $0.content }
            .asObservable()
    }
}
