//
//  ApiManager.swift
//  JatAppTest
//
//  Created by Ihor Zaliskyj on 21.11.2022.
//

import Foundation

let top250MoviesUrl = "https://imdb-api.com/en/API/Top250Movies/k_nnlqtizq"

class ApiManager {
    
    enum APIError: Error {
        case networkError(Error)
        case dataNotFound
        case jsonParsingError(Error)
        case invalidStatusCode(Int)
        case badURL(String)
    }

    enum Result<T> {
        case success(T)
        case failure(APIError)
    }

    class func dataRequest<T: Decodable>(with url: String, objectType: T.Type, completion: @escaping (Result<T>) -> Void) {

        guard let dataURL = URL(string: url) else {
           completion(.failure(APIError.badURL(url)))
           return
        }
       
        let session = URLSession.shared
        
        
        let request = URLRequest(url: dataURL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(Result.failure(APIError.networkError(error!)))
                return
            }
            
            guard let data = data else {
                completion(Result.failure(APIError.dataNotFound))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                completion(Result.success(decodedObject))
            } catch let error {
                completion(Result.failure(APIError.jsonParsingError(error as! DecodingError)))
            }
        })
        
        task.resume()
    }
}

