//
//  HeroesSkillEntity.swift
//  Heroes iOS
//
//  Created by TR64UV on 09/11/2020.
//

import Foundation
typealias HeroesSkillsList = [HeroesSkillsEntity]
struct HeroesSkillsEntity: Decodable {
    let id: Int
    let name, heroesSkillsEntityDescription: String
    let modified: Date
    let thumbnail: Thumbnail
    let heroeUrl: [HeroeURLEntity]
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case heroesSkillsEntityDescription = "description"
        case modified, thumbnail
        case heroeUrl = "urls"
    }
}

extension HeroesSkillsEntity {
    /// We map the Domain layer to Presentation layer model
    /// - Returns: The heroes model :), our presentation model
    func toHeroesModel() -> HeroesModel {
        let imageUrl = "\(thumbnail.path)/portrait_fantastic.\(thumbnail.thumbnailExtension)"
        let moreDetailElements =  heroeUrl.enumerated().map({ index,
                                                              element in
                                                                MoreDetailsLinkModel(tagId: index,
                                                                                     name: element.type,
                                                                                     url: element.url)})
        return .init(id: self.id,
                     name: self.name,
                     description: self.heroesSkillsEntityDescription,
                     imageUrl: imageUrl,
                     moreDetailElements: moreDetailElements)
    }
}
