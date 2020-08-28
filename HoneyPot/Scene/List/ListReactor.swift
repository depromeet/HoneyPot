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
        initialState = State(keyword: keyword, category: category)
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
        var isRefreshing: Bool = false
        var isLoading: Bool = false
        var isLast: Bool = false
    }

    enum Action {
        case refresh
        case load
        case selectCategory(String)
        case selectSortIndex(Int)
    }

    enum Mutation {
        case setItems([ItemEntity])
        case appendItems([ItemEntity])
        case setCategory(String)
        case setSortTitle(Int)
        case setRefreshing(Bool)
        case setLoading(Bool)
        case setPageIndex(Int)
        case setLast(Bool)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            let category = currentState.category
            let sort = currentState.sortList[currentState.sortIndex].rawValue
            return Observable.concat(
                refresh(category: category, sort: sort),
                .just(Mutation.setPageIndex(0)),
                .just(Mutation.setLast(false))
            )
        case .load:
            guard !currentState.isLoading, !currentState.isLast else { return .empty() }
            let index = currentState.pageIndex + 1
            return Observable.concat(
                load(index: index),
                .just(Mutation.setPageIndex(index))
            )
        case let .selectCategory(category):
            let sort = currentState.sortList[currentState.sortIndex].rawValue
            return Observable.concat(
                .just(Mutation.setCategory(category)),
                refresh(category: category, sort: sort)
            )
        case let .selectSortIndex(index):
            let category = currentState.category
            let sort = currentState.sortList[index].rawValue
            return Observable.concat(
                .just(Mutation.setSortTitle(index)),
                refresh(category: category, sort: sort)
            )
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setItems(items):
            state.items = items
        case let .appendItems(items):
            state.items += items
        case let .setCategory(category):
            state.category = category
        case let .setSortTitle(index):
            state.sortIndex = index
            state.sortTitle = state.sortList[index].title
        case let .setRefreshing(isRefreshing):
            state.isRefreshing = isRefreshing
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setPageIndex(index):
            state.pageIndex = index
        case let .setLast(isLast):
            state.isLast = isLast
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
                .flatMap { items, isLast -> Observable<Mutation> in
                    Observable.concat(
                        .just(Mutation.setItems(items)),
                        .just(Mutation.setLast(isLast))
                    )
                }
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
                .flatMap { items, isLast -> Observable<Mutation> in
                    Observable.concat(
                        .just(Mutation.appendItems(items)),
                        .just(Mutation.setLast(isLast))
                    )
                }
                .observeOn(MainScheduler.asyncInstance),
            .just(Mutation.setLoading(false))
        )
    }

    private func requestItems(
        category: String,
        sort: String,
        index: Int = 0
    ) -> Observable<([ItemEntity], Bool)> {
        let keyword = currentState.keyword
        return provider.networkService
            .request(.posts(keyword, category, sort, index), type: PageableList<ItemEntity>.self, #file, #function, #line)
            .map { ($0.content, $0.last) }
            .asObservable()
    }
}
