//
//  QiitaAPI.swift
//  MySampleApp
//
//  Created by yukatou on 2017/12/24.
//  Copyright © 2017年 yukatou. All rights reserved.
//

import Foundation
import Moya

enum QiitaAPI {
    case items(query: String?)
}

extension QiitaAPI: TargetType {

    var baseURL: URL {
        return URL(string: "https://qiita.com")!
    }

    var path: String {
        return "/api/v2/items"
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {

        if case .items(let query) = self {

            var parameters: [String: Any] = [
                "page": 1,
                "per_page": 20,
            ]

            if let query = query {
                parameters["query"] = query
            }

            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }

        return .requestPlain
    }

    var sampleData: Data {
        return "success".data(using: .utf8)!
    }

    var headers: [String : String]? {
        return ["Accept": "application/json"]
    }
}
