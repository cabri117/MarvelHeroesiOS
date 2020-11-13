//
//  NetworkDataTransferService.swift
//  Heroes iOS
//
//  Created by TR64UV on 09/11/2020.
//

import Foundation
class DataTransferService {
    private let session = URLSession.shared
    
    func request(with endpoint: URLRequest,
                 result: @escaping (Result<Data, DataTransferError>) -> Void) {
        
        func asyncCompletition(_ response: Result<Data, DataTransferError>) {
            DispatchQueue.main.async {
                result(response)
            }
        }
        
        let task = session.dataTask(with: endpoint) { data, response, error in
            
            guard error == nil else {
                asyncCompletition(.failure(DataTransferError.resolvedNetworkFailure(error!)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                asyncCompletition(.failure(DataTransferError.networkFailure(httpResponse.statusCode)))
                return
            }
            
            guard let mime = response?.mimeType,
                  mime == Constants.DataConfiguration.mimeType else {
                asyncCompletition(.failure(DataTransferError.mimeError))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let jsonData  = json[Constants.DataConfiguration.data] as? [String: Any],
                  let jsonResults = jsonData[Constants.DataConfiguration.results],
                  let resultData = try? JSONSerialization.data(withJSONObject: jsonResults, options: .prettyPrinted) else {
                asyncCompletition(.failure(DataTransferError.parsingError))
                return
            }
            
            asyncCompletition(.success(resultData))
        }
        task.resume()
    }
}

enum DataTransferError: Error {
    case parsingError
    case noResponse
    case mimeError
    case resolvedNetworkFailure(Error)
    case networkFailure(Int)
    case endpointError
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
