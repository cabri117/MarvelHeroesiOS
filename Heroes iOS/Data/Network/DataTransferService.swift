//
//  NetworkDataTransferService.swift
//  Heroes iOS
//
//  Created by TR64UV on 09/11/2020.
//

import Foundation
/// The class how manage API calls services
class DataTransferService {
    // MARK: Private Variables
    private let session = URLSession.shared
    /// Request method to the API service
    /// - Parameters:
    ///   - endpoint: The endpoint that we need to call
    ///   - result: The final result of the call. It can be success or mfailure
    func request(with endpoint: URLRequest,
                 result: @escaping (Result<Data, DataTransferError>) -> Void) {
        // The final async result, we manage to use Grand Central Dispatch async
        func asyncCompletition(_ response: Result<Data, DataTransferError>) {
            DispatchQueue.main.async {
                result(response)
            }
        }
        // We use Url Session
        let task = session.dataTask(with: endpoint) { data, response, error in
            // Do we have a error?
            guard error == nil else {
                asyncCompletition(.failure(DataTransferError.resolvedNetworkFailure(error!)))
                return
            }
            //do we have a responde body?
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            // Is this response is succeed?
            guard (200...299).contains(httpResponse.statusCode) else {
                asyncCompletition(.failure(DataTransferError.networkFailure(httpResponse.statusCode)))
                return
            }
            // Is tha mime type a json type?
            guard let mime = response?.mimeType,
                  mime == Constants.DataConfiguration.mimeType else {
                asyncCompletition(.failure(DataTransferError.mimeError))
                return
            }
            // we Data map the marvel rresult
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let jsonData  = json[Constants.DataConfiguration.data] as? [String: Any],
                  let jsonResults = jsonData[Constants.DataConfiguration.results],
                  let resultData = try? JSONSerialization.data(withJSONObject: jsonResults,
                    options: .prettyPrinted) else {
                asyncCompletition(.failure(DataTransferError.parsingError))
                return
            }
            asyncCompletition(.success(resultData))
        }
        task.resume()
    }
}
/// We manage the data transfer with a error enums
enum DataTransferError: Error {
    case parsingError
    case noResponse
    case mimeError
    case resolvedNetworkFailure(Error)
    case networkFailure(Int)
    case endpointError
}
/// The method types we have available, we can also add DELETE, PUT, and UPDATE.
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
