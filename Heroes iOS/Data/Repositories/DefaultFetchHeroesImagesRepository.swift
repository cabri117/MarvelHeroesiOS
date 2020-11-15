//
//  FetchHeroesImage.swift
//  Heroes iOS
//
//  Created by TR64UV on 15/11/2020.
//

import Foundation
class DefaultFetchHeroesImagesRepository: FetchHeroesImagesRepository {
    private var loadedImages = [URL: Data]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    func loadImage(_ url: URL, _ completion: @escaping (Result<Data, Error>) -> Void) -> UUID? {
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }
        let uuid = UUID()
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            defer {self.runningRequests.removeValue(forKey: uuid) }
            if let data = data {
                self.loadedImages[url] = data
                completion(.success(data))
                return
            }
            guard let error = error else {
                completion(.failure(DataTransferError.endpointError))
                return
            }
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
        }
        task.resume()
        runningRequests[uuid] = task
        return uuid
    }
    func cancelLoad(_ uuid: UUID) {
      runningRequests[uuid]?.cancel()
      runningRequests.removeValue(forKey: uuid)
    }
}
