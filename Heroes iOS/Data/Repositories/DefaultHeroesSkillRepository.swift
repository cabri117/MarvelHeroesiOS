//
//  DefaultHeroesSkillRepository.swift
//  Heroes iOS
//
//  Created by TR64UV on 09/11/2020.
//

import Foundation
final class DefaultHeroesSkillRepository {
    // MARK: Private Dependencies
    private let dataTransferService: DataTransferService
    // MARK: Init
    init(dataTransferService: DataTransferService = DataTransferService()) {
        self.dataTransferService = dataTransferService
    }
}
// MARK: HeroesSkillRepository Interface
extension DefaultHeroesSkillRepository: HeroesSkillsRepository {
    /// We fetch the herroes skills list
    /// - Parameters:
    ///   - offset: The number of element we want, we can ask for more
    ///   - completion: The final result of the Domain to Data call, we also map the result to Domain layer
    func fetchHeroesSkillsList(offset: Int,
                               completion: @escaping (Result<HeroesSkillsList, DataTransferError>) -> Void) {
        // We check is the endpoint is ok
        guard let endpoint = APIEndpoints.getCharacters(offset: offset) else {
            return completion(.failure(DataTransferError.endpointError))
        }
        // We perform the request to the Data Layer
        dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let data):
                // We check if the model accomplish what we want with codable and the json manager
                guard let heroesSkillList = try? JsonCodableManagment.newJSONDecoder().decode(HeroesSkillsList.self,
                                                                                              from: data) else {
                    completion(.failure(DataTransferError.parsingError))
                    return
                }
                completion(.success(heroesSkillList))
            case .failure(let error):
                // We fail the call to Data layer, example an 500? :(
                completion(.failure(error))
            }
        }
    }
}
