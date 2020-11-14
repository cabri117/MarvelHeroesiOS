//
//  HeroesModel.swift
//  Heroes iOS
//
//  Created by TR64UV on 09/11/2020.
//

import Foundation
struct HeroesModel {
    let id: Int
    let name, description: String
    let imageUrl: String?
    let moreDetailElements: [MoreDetailsLinkModel]
}

struct MoreDetailsLinkModel {
    let tagId: Int
    let name: String
    let url: String
}
