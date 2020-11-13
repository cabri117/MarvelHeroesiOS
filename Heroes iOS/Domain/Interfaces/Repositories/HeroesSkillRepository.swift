//
//  HeroesSkillRepository.swift
//  Heroes iOS
//
//  Created by TR64UV on 09/11/2020.
//

import Foundation
protocol HeroesSkillsRepository {
    func fetchHeroesSkillsList(offset: Int, completion: @escaping (Result<HeroesSkillsList, DataTransferError>) -> Void)
}
