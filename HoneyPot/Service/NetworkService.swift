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
import Moya
import MoyaSugar

protocol NetworkServiceType {
    func request<T: Decodable>(
        _ target: HoneyPotAPI,
        onSuccess: @escaping ((T) -> Void),
        onError: ((Error) -> Void)?
    )
    func request<T: Decodable>(
        _ target: HoneyPotAPI,
        type: T.Type,
        _ file: StaticString,
        _ function: StaticString,
        _ line: UInt
    ) -> Single<T>
}

class NetworkService: BaseService, NetworkServiceType {
    private lazy var endpointClosure = { [weak self] (target: HoneyPotAPI) -> Endpoint in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        if let userID = self?.provider.accountService.userID {
            return defaultEndpoint.adding(newHTTPHeaderFields: ["User-ID": userID])
        } else {
            return defaultEndpoint
        }
    }
    private lazy var networkProvider = MoyaSugarProvider(endpointClosure: endpointClosure)
    private var disposeBag = DisposeBag()

    /// 기본 API 호출 메소드
    /// - Parameters:
    ///   - target: 호출할 API 예) HoneyPotAPI.user
    ///   - onSuccess: 성공 콜백
    ///   - onError: 실패 콜백
    func request<T: Decodable>(
        _ target: HoneyPotAPI,
        onSuccess: @escaping ((T) -> Void),
        onError: ((Error) -> Void)?
    ) {
        networkProvider.rx.request(target)
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

    func request<T: Decodable>(
        _ target: HoneyPotAPI,
        type: T.Type,
        _ file: StaticString,
        _ function: StaticString,
        _ line: UInt
    ) -> Single<T> {
        let requestString = "\(target.method.rawValue) \(target.path)"
        return networkProvider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { value in
                    let message = "SUCCESS: \(requestString) (\(value.statusCode))"
                    log.debug(message, file: file, function: function, line: line)
                },
                onError: { error in
                    if let response = (error as? MoyaError)?.response {
                        if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                            log.warning(message, file: file, function: function, line: line)
                        } else if let rawString = String(data: response.data, encoding: .utf8) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                            log.warning(message, file: file, function: function, line: line)
                        } else {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))"
                            log.warning(message, file: file, function: function, line: line)
                        }
                    } else {
                        let message = "FAILURE: \(requestString)\n\(error)"
                        log.warning(message, file: file, function: function, line: line)
                    }
                },
                onSubscribed: {
                    let message = "REQUEST: \(requestString)"
                    log.debug(message, file: file, function: function, line: line)
                }
            )
            .map(T.self)
            .do(
                onError: { error in
                    if let error = (error as? MoyaError) {
                        let code = error.errorCode
                        var message: String
                        if let description = error.errorDescription {
                            message = "FAILURE: \(requestString) (\(code)) (\(description))"
                        } else {
                            message = "FAILURE: \(requestString) (\(code))"
                        }
                        log.warning(message, file: file, function: function, line: line)
                    }
            }
        )
    }
}
