//
//  VolumesResponse.swift
//  MySampleApp
//
//  Created by yukatou on 2017/12/03.
//  Copyright © 2017年 yukatou. All rights reserved.
//

import Foundation

struct VolumesResponse: Codable {
    let items: [Volume]
}

struct Volume: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let imageLinks: ImageLinks?
}

struct ImageLinks: Codable {
    let thumbnail: String
}

extension VolumeInfo {
    func imageURL() -> URL? {
        var imageURL: URL?
        if let imageLinks = self.imageLinks {
            imageURL = URL(string: imageLinks.thumbnail.convertHttps())
        }
        return imageURL
    }
}
