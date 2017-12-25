//
//  QiitaItem.swift
//  MySampleApp
//
//  Created by yukatou on 2017/12/24.
//  Copyright © 2017年 yukatou. All rights reserved.
//

import Foundation

struct QiitaItem: Codable {
    let id: String
    let title: String
    let url: URL
    let createdAt: Date

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case url
        case createdAt = "created_at"
    }
}
