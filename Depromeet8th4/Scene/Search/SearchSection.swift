//
//  SearchSection.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/08.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import RxDataSources

struct SearchSection {
    var header: String
    var items: [Item]
}

extension SearchSection: SectionModelType {
    typealias Item = String

    init(original: SearchSection, items: [Item]) {
        self = original
        self.items = items
    }
}
