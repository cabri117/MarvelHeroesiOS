//
//  FetchHeroesSkillUseCase.swift
//  Heroes iOS
//
//  Created by TR64UV on 09/11/2020.
//

import Foundation
/// Our heroes skills use case :)
final class FetchHeroesSkillsListUseCase {
    // MARK: Private var and dependencies
    private var currentOffset = 0
    private lazy var heroesSkillsRepository: HeroesSkillsRepository = {
        return DefaultHeroesSkillRepository()
    }()
    /// We perform the sue case, we call our domain repository and receive the entitiy
    /// - Parameter completion: The final reesult, we send this to the view model
    func execute(completion: @escaping (Result<[HeroesModel], Error>) -> Void) {
        heroesSkillsRepository.fetchHeroesSkillsList(offset: currentOffset){ [weak self] result in
            // This can be a weak reference, so we can check if this is not free of the ARC
            guard let self = self else {
                completion(.failure(DataTransferError.parsingError))
                return
            }
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
