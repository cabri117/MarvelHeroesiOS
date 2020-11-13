//
//  FetchHeroesSkillUseCase.swift
//  Heroes iOS
//
//  Created by TR64UV on 09/11/2020.
//

import Foundation

final class FetchHeroesSkillsListUseCase {
    private var currentOffset = 0
    private lazy var heroesSkillsRepository: HeroesSkillsRepository = {
        return DefaultHeroesSkillRepository()
    }()
    
    func execute(completion: @escaping (Result<[HeroesModel], Error>) -> Void) {
        heroesSkillsRepository.fetchHeroesSkillsList(offset: currentOffset){ result in
            switch result {
            case .success(let entityList):
                let heroModelList = entityList.map { $0.toHeroesModel()}
                self.currentOffset = self.currentOffset + 40
                completion(.success(heroModelList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
