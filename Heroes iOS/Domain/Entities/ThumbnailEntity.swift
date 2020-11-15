//
//  ThumbnailEntity.swift
//  Heroes iOS
//
//  Created by TR64UV on 09/11/2020.
//

import Foundation
// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}
