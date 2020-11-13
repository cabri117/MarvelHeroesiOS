//
//  DefaultHeroesSkillRepository.swift
//  Heroes iOS
//
//  Created by TR64UV on 09/11/2020.
//

import Foundation
final class DefaultHeroesSkillRepository {
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService = DataTransferService()) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultHeroesSkillRepository: HeroesSkillsRepository {
    func fetchHeroesSkillsList(offset: Int, completion: @escaping (Result<HeroesSkillsList, DataTransferError>) -> Void) {
        debugPrint(String(describing:offset))
        guard let endpoint = APIEndpoints.getCharacters(offset: offset) else {
            return completion(.failure(DataTransferError.endpointError))
        }
        dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let data):
                guard let heroesSkillList = try? JsonCodableManagment.newJSONDecoder().decode(HeroesSkillsList.self,
                                                                                              from: data) else {
                    completion(.failure(DataTransferError.parsingError))
                    return
                }
                completion(.success(heroesSkillList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
