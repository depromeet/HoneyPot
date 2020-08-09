//
//  SearchWordService.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/08.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation
import RxSwift

extension UserDefaultsKey {
    static var searchWords: Key<[String: Double]> {
        return "searchWords"
    }
}

protocol SearchWordServiceType {
    func getWords() -> Observable<[String: Double]>
    func addWord(word: String) -> Observable<[String: Double]>
    func removeWord(word: String) -> Observable<[String: Double]>
}

final class SearchWordService: BaseService, SearchWordServiceType {
    @discardableResult
    private func saveWords(_ words: [String: Double]) -> Observable<Void> {
        self.provider.userDefaultsService.set(value: words, forKey: .searchWords)
        return .just(Void())
    }

    func getWords() -> Observable<[String: Double]> {
        if let words = provider.userDefaultsService.value(forKey: .searchWords) {
            return .just(words)
        } else {
            return .just([:])
        }
    }

    func addWord(word: String) -> Observable<[String: Double]> {
        return getWords()
            .flatMap({ [weak self] words -> Observable<Void> in
                guard let self = self else { return .empty() }
                var words = words
                words[word] = Date().timeIntervalSince1970
                return self.saveWords(words)
            })
            .flatMap({ [weak self] in
                return self?.getWords() ?? .empty()
            })
    }

    func removeWord(word: String) -> Observable<[String: Double]> {
        return getWords()
            .flatMap({ [weak self] words -> Observable<Void> in
                guard let self = self else { return .empty() }
                var words = words
                words[word] = nil
                return self.saveWords(words)
            })
            .flatMap({ [weak self] in
                return self?.getWords() ?? .empty()
            })
    }
}
