//
//  QiitaResponse.swift
//  MySampleApp
//
//  Created by yukatou on 2017/12/24.
//  Copyright © 2017年 yukatou. All rights reserved.
//

import Foundation

struct QiitaResponse: Codable {
    let items: [QiitaItem]
}

extension QiitaResponse {
    init(from decoder: Decoder) throws {
        var items: [QiitaItem] = []
        var unkeyedContainer = try decoder.unkeyedContainer()
        while (!unkeyedContainer.isAtEnd) {
            let item = try unkeyedContainer.decode(QiitaItem.self)
            items.append(item)
        }
        self.init(items: items)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for item in items {
            try container.encode(item)
        }
    }
}
