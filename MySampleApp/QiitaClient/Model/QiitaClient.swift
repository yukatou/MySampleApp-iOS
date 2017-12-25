//
//  QiitaClient.swift
//  MySampleApp
//
//  Created by yukatou on 2017/12/24.
//  Copyright © 2017年 yukatou. All rights reserved.
//

import Foundation
import Moya
import RxSwift


class QiitaClient {

    let provider = MoyaProvider<QiitaAPI>()

    func fetch(query: String?, completion: @escaping ([QiitaItem]) -> Void) -> Cancellable {
        let task = provider.request(.items(query: query)) { result in
            switch result {
            case .success(let response):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                do {
                    let arr = try jsonDecoder.decode(QiitaResponse.self, from: response.data)
                    completion(arr.items)
                } catch let error as NSError {
                    fatalError(error.localizedDescription)
                }
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }

        return task
    }
}

extension QiitaClient: ReactiveCompatible {
}

extension Reactive where Base: QiitaClient {
    func fetch(query: String?) -> Single<[QiitaItem]> {
        return Single.create { single in
            let request = self.base.fetch(query: query) { items in
                single(.success(items))
            }

            return Disposables.create {
                request.cancel()
            }
        }.observeOn(MainScheduler.instance)
    }
}
