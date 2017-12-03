//
//  GoogleBookAPI.swift
//  MySampleApp
//
//  Created by yukatou on 2017/12/03.
//  Copyright © 2017年 yukatou. All rights reserved.
//

import Foundation
import Moya


enum GoogleBookAPI {
    case volumes(query: String)
    case volume(id: String)
}

extension GoogleBookAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://www.googleapis.com/books/v1")!
    }
    
    var path: String {
        switch self {
        case .volumes(_):
            return "/volumes"
        case .volume(let id):
            return "/volumes/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .volumes, .volume: return .get
        }
    }

    var task: Task {
        switch self {
        case .volumes(let query):
            return .requestParameters(parameters: ["q": query], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }

    var sampleData: Data {
        switch self {
        case .volumes(let query):
            return "{\"q\": \"\(query)\"}".data(using: .utf8)!
        case .volume(let id):
            return "{\"id\": \"\(id)\"}".data(using: .utf8)!
        }
    }

    var headers: [String : String]? {
        return ["ContentType": "application/json"]
    }
}
