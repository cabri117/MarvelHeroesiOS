//
//  HeroesSkillEntity.swift
//  Heroes iOS
//
//  Created by TR64UV on 09/11/2020.
//

import Foundation
typealias HeroesSkillsList = [HeroesSkillsEntity]
struct HeroesSkillsEntity: Decodable {
    let identifier: Int
    let name, heroesSkillsEntityDescription: String
    let modified: Date
    let thumbnail: Thumbnail
    let heroeUrl: [HeroeURLEntity]
    let comicsAvailable: ResourcesEntity?
    let seriesAvailable: ResourcesEntity?
    let storiesAvailable: ResourcesEntity?
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case heroesSkillsEntityDescription = "description"
        case modified, thumbnail
        case heroeUrl = "urls"
        case comicsAvailable = "comics"
        case seriesAvailable = "series"
        case storiesAvailable = "stories"
    }
}

extension HeroesSkillsEntity {
    /// We map the Domain layer to Presentation layer model
    /// - Returns: The heroes model :), our presentation model
    func toHeroesModel() -> HeroesModel {
        let imageUrl = "\(thumbnail.path)/portrait_xlarge.\(thumbnail.thumbnailExtension)"
        let moreDetailElements =  heroeUrl.enumerated().map({ index, element in
                                                                MoreDetailsLinkModel(tagId: index,
                                                                                     name: element.type,
                                                                                     url: element.url)})
        return .init(identifier: self.identifier,
                     name: self.name,
                     description: self.heroesSkillsEntityDescription,
                     imageUrl: imageUrl,
                     howManyComics: self.comicsAvailable?.available,
                     howManyStories: self.storiesAvailable?.available,
                     howManySeries: self.seriesAvailable?.available,
                     moreDetailElements: moreDetailElements)
    }
}
