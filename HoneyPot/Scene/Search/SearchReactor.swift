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
        var words: [SearchSection] = []
        var shouldShowResults: Bool = false
    }
    enum Action {
        case refresh
        case inputSearchText(String)
        case addWord(String)
        case removeWord(String)
        case removeAllWords
    }
    enum Mutation {
        case setSearchText(String)
        case setWords([SearchSection])
        case setShouldShowResults(Bool)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return provider.searchWordService.getWords()
                .flatMap({ [weak self] in
                    return self?.convertWords(words: $0) ?? .empty()
                })
        case .inputSearchText(let text):
            return .just(Mutation.setSearchText(text))
        case .addWord(let word):
            let addWord = provider.searchWordService.addWord(word: word)
                .flatMap({ [weak self] in
                    return self?.convertWords(words: $0) ?? .empty()
                })
            return Observable.concat(
                addWord,
                .just(Mutation.setShouldShowResults(true)),
                .just(Mutation.setShouldShowResults(false))
            )
        case .removeWord(let word):
            return provider.searchWordService.removeWord(word: word)
                .flatMap({ [weak self] in
                    return self?.convertWords(words: $0) ?? .empty()
                })
        case .removeAllWords:
            return provider.searchWordService.removeAllWords()
                .flatMap({ [weak self] in
                    return self?.convertWords(words: $0) ?? .empty()
                })
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setSearchText(let text):
            state.searchText = text
        case .setWords(let words):
            state.words = words
        case .setShouldShowResults(let shouldShowResults):
            state.shouldShowResults = shouldShowResults
        }
        return state
    }

    func convertWords(words: [String: Double]) -> Observable<Mutation> {
        return Observable.just(words)
            .map({ dictionary in
                let items = dictionary
                    .sorted(by: { $0.value > $1.value })
                    .reduce(into: [String](), { $0.append($1.key) })
                    .prefix(8)
                let section = SearchSection(header: "최근검색어", items: Array(items))
                return Mutation.setWords([section])
            })
    }
}
