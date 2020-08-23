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

    init(provider: ServiceProviderType, keyword: String = "") {
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
        var items: [ItemEntity] = []
    }
    enum Action {
        case refresh
        case selectSortIndex(Int)
    }
    enum Mutation {
        case setItems([ItemEntity])
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
            state.sortIndex = index
            state.sortTitle = state.sortList[index].title
        }
        return state
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
