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
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return refresh()
        case .load:
            guard !currentState.isLoading else { return .empty() }
            return load()
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
        }
        return state
    }

    private func refresh(
        category: String? = nil,
        sort: String? = nil
    ) -> Observable<Mutation> {
        return Observable.concat(
            .just(Mutation.setRefreshing(true)),
            requestItems().map({ Mutation.setItems($0) })
                .observeOn(MainScheduler.asyncInstance),
            .just(Mutation.setRefreshing(false))
        )
    }
    private func load(
        category: String? = nil,
        sort: String? = nil
    ) -> Observable<Mutation> {
        return Observable.concat(
            .just(Mutation.setLoading(true)),
            requestItems().map({ Mutation.appendItems($0) })
                .observeOn(MainScheduler.asyncInstance),
            .just(Mutation.setLoading(false))
        )
    }
    private func requestItems() -> Observable<[ItemEntity]> {
        return .just([
            ItemEntity(
                id: 1,
                thumbnail: "",
                numberOfWish: 302,
                numberOfComment: 13,
                title: "테이블팬 C820 (3 Colors)",
                category: "가전",
                sellerName: "플러스마이너스제로",
                price: 50000,
                nowDiscount: .init(step: 1, numberOfPeople: 100, discountPercent: 35),
                nextDiscount: .init(step: 2, numberOfPeople: 200, discountPercent: 40),
                participants: 130,
                numberOfGoal: 300,
                deadline: "2020-09-10 23:59:59")
            ]
        )
    }
}
