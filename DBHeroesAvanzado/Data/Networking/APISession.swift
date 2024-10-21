//
//  ApiProvider.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 15/10/24.
//

import Foundation

protocol APISessionProtocol {
    func loadHeros(name: String, completion: @escaping ((Result<[APIHero], APIErrorResponse>) -> Void))
    func loadLocations(id: String, completion: @escaping ((Result<[APILocation], APIErrorResponse>) -> Void))
    func loadtransformation(id: String, completion: @escaping ((Result<[APITransformation], APIErrorResponse>) -> Void))
}

final class APISession: APISessionProtocol {
    
    private let session: URLSession
    private let requestBuilder: APIRequestBuilder
    
    init(session: URLSession = .shared, requestBuilder: APIRequestBuilder = APIRequestBuilder()) {
        self.session = session
        self.requestBuilder = requestBuilder
        
    }
    
    func loadHeros(name: String = "",completion: @escaping ((Result<[APIHero], APIErrorResponse>) -> Void)) {
        
        do {
            let request = try requestBuilder.buildRequest(endPoint: .heroes, params: ["name": name])
            makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    func loadLocations(id: String, completion: @escaping ((Result<[APILocation], APIErrorResponse>) -> Void)) {
        do {
            let request = try requestBuilder.buildRequest(endPoint: .locations, params: ["id": id])
                makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    func loadtransformation(id: String, completion: @escaping ((Result<[APITransformation], APIErrorResponse>) -> Void)) {
        do {
            let request = try requestBuilder.buildRequest(endPoint: .transformations, params: ["id": id])
                makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    
    private func makeRequest<T: Decodable>(request: URLRequest,completion: @escaping ((Result<T, APIErrorResponse>) -> Void)) {
        session.dataTask(with: request) {data, response, error in
            if let error {
                completion(.failure(.errorFromServer(error: error)))
            }
            
            let httpResponse = response as? HTTPURLResponse
            let statusCode = httpResponse?.statusCode
            if httpResponse?.statusCode != 200 {
                completion(.failure(.errorFromApi(statusCode: statusCode ?? -1)))
                return
            }
            if let data {
                do {
                    let apiInfo = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(apiInfo))
                } catch {
                    completion(.failure(.dataNoReceived))
                }
            } else {
                completion(.failure(.dataNoReceived))
            }
        }.resume()
    }
}
