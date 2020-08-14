//
//  ItemReactor.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/13.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation
import ReactorKit

final class ItemReactor: Reactor {
    let provider: ServiceProviderType

    init(provider: ServiceProviderType, itemID: String) {
        self.provider = provider
        self.initialState = State(itemID: itemID)
    }
    // MARK: - Reactor
    var initialState: State

    struct State {
        let itemID: String
    }
    enum Action {
    }
    enum Mutation {
    }
}
