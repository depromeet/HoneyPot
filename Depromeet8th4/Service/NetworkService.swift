//
//  NetworkService.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/07/16.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation
import RxSwift
import RxMoya
import MoyaSugar

protocol NetworkServiceType {
    func request<T: Decodable>(
        _ target: SugarTargetType,
        onSuccess: @escaping ((T) -> Void),
        onError: ((Error) -> Void)?
    )
}

class NetworkService: BaseService, NetworkServiceType {
    private let networkProvider = MoyaSugarProvider<MultiSugarTarget>()
    private var disposeBag = DisposeBag()

    /// 기본 API 호출 메소드
    /// - Parameters:
    ///   - target: 호출할 API 예) ItemAPI.fetchItems("검색어")
    ///   - onSuccess: 성공 콜백
    ///   - onError: 실패 콜백
    func request<T: Decodable>(
        _ target: SugarTargetType,
        onSuccess: @escaping ((T) -> Void),
        onError: ((Error) -> Void)?
    ) {
        let multiTarget = MultiSugarTarget(target)
        networkProvider.rx.request(multiTarget)
            .map(T.self)
            .subscribe(
                onSuccess: { data in
                    onSuccess(data)
                },
                onError: { error in
                    onError?(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
