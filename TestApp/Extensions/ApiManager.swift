//
//  ApiManager.swift
//  JatAppTest
//
//  Created by Ihor Zaliskyj on 21.11.2022.
//

import Foundation

enum APIError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
    case badURL(String)
}

enum Result<Success, Failure: Error> {
    case success(Success)
    case error(Failure)
}

class ApiManager {
    
    static var shared = ApiManager()
    let decoder = JSONDecoder()
    
    
    func loadTop250MoviesRequest(with url: String, completion: @escaping (Result<MoviesResponse, APIError>) -> Void) {

        guard let dataURL = URL(string: url) else {
            completion(.error(.badURL(url)))
           return
        }
       
        let session = URLSession.shared
        let request = URLRequest(url: dataURL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: Double.infinity)
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(.error(.networkError(error!)))
                return
            }
            
            guard let data = data else {
                completion(.error(.dataNotFound))
                return
            }
            
            do {
                if let decodedObject = try self.decoder.decode(MoviesResponse?.self, from: data) {
                    completion(.success(decodedObject))
                }
            } catch let error {
                if let decodingError = error as? DecodingError {
                    completion(.error(.jsonParsingError(decodingError)))
                }
            }
        })
        
        task.resume()
    }
    
    
}

