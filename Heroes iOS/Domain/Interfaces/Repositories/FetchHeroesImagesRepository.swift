//
//  FetchHeroesImagesRepository.swift
//  Heroes iOS
//
//  Created by TR64UV on 15/11/2020.
//

import Foundation
protocol FetchHeroesImagesRepository {
    func loadImage(_ url: URL, _ completion: @escaping (Result<Data, Error>) -> Void) -> UUID?
    func cancelLoad(_ uuid: UUID)
}
