//
//  APIProviderMock.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 27/10/24.
//

@testable import DBHeroesAvanzado

class ApiProviderMock: APISessionProtocol {
    func loadHeros(name: String, completion: @escaping ((Result<[APIHero], DBHeroesAvanzado.APIErrorResponse>) -> Void)) {
        do {
            let heroes = try MockData.mockHeroes()
            completion(.success(heroes))
        } catch {
            completion(.failure(APIErrorResponse.noData))
        }
    }
    
    func loadLocations(id: String, completion: @escaping ((Result<[APILocation], APIErrorResponse>) -> Void)) {
        let locations = [APILocation(id: "id", date: "date", latitude: "latitud", longitude: "0000", hero: nil)]
        completion(.success(locations))
    }
    
    func loadtransformation(id: String, completion: @escaping ((Result<[APITransformation], APIErrorResponse>) -> Void)) {
        let transformations = [APITransformation(id: "id", name: "name", description: "desc", photo: "photo", hero: nil)]
        completion(.success(transformations))
    }
    
    func login(user: String, password: String, completion: @escaping ((Result<String, APIErrorResponse>) -> Void)) {
        let token = "token"
        completion(.success(token))
    }
    
    
}

class ApiProviderErrorMock: APISessionProtocol {
    func loadtransformation(id: String, completion: @escaping ((Result<[APITransformation],APIErrorResponse>) -> Void)) {
        completion(.failure(APIErrorResponse.noData))
    }
    
    func login(user: String, password: String, completion: @escaping ((Result<String,APIErrorResponse>) -> Void)) {
        completion(.failure(APIErrorResponse.noData))
    }
    
    func loadHeros(name: String, completion: @escaping((Result<[APIHero], APIErrorResponse>) -> Void)) {
        completion(.failure(APIErrorResponse.noData))
    }
    func loadLocations(id: String, completion: @escaping((Result<[APILocation], APIErrorResponse>) -> Void)) {
        completion(.failure(APIErrorResponse.noData))
    }
    
    
}
