//
//  HeroTransformationUseCase.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 25/10/24.
//

import Foundation

protocol HeroTransformationUseCaseProtocol {
    func loadTransformation(id: String, transformation: String, completion: @escaping ((Result<Transformation, APIErrorResponse>)) -> Void)
}


final class HeroTransformationUseCase: HeroTransformationUseCaseProtocol {
    
    private let allTransformations: HeroDetailUseCaseProtocol
    private var apiProvider: APISessionProtocol
    private var StoreData: StoreDataProvider
    
    init(apiProvider: APISessionProtocol = APISession(), StoreData: StoreDataProvider = .shared ,allTransformations: HeroDetailUseCaseProtocol = HeroDetailUseCase()) {
        self.apiProvider = apiProvider
        self.StoreData = StoreData
        self.allTransformations = allTransformations
    }
    
    func loadTransformation(id: String,transformation: String, completion: @escaping ((Result<Transformation, APIErrorResponse>)) -> Void) {
        allTransformations.loadTransformationsForHeroWith(id: id) {result in
            switch result {
            case .success(let transformations):
                let transformation = transformations.first(where: { $0.name == transformation })
                completion(.success(transformation!))
            case .failure(_):
                completion(.failure(.noData))
            }
        }
    }
    
    
}
        
