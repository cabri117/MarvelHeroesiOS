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

    enum CodingKeys: String, CodingKey {
        case id, name
        case heroesSkillsEntityDescription = "description"
        case modified, thumbnail
    }
}

extension HeroesSkillsEntity {
    func toHeroesModel() -> HeroesModel {
        let imageUrlPortraitSmall = "\(thumbnail.path)/portrait_small.\(thumbnail.thumbnailExtension)"
        let imageUrlPortraitMedium = "\(thumbnail.path)/portrait_fantastic.\(thumbnail.thumbnailExtension)"
        return .init(id: self.id,
                     name: self.name,
                     description: self.heroesSkillsEntityDescription,
                     imageUrlPortraitSmall: imageUrlPortraitSmall,
                     imageUrlPortraitMedium: imageUrlPortraitMedium)
    }
}
