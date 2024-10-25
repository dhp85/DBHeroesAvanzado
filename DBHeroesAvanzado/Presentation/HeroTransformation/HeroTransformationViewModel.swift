//
//  HeroTransformationViewModel.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 25/10/24.
//

import Foundation

enum HeroTransformationState {
    case none
    case success
    case error(reason: String)
}


final class HeroTransformationViewModel {
    
    
    let status = Binding<HeroTransformationState>(.none)
    
    private(set) var heroName: Hero
    
    private(set) var transformation: Transformation
    
    private var useCase: HeroTransformationUseCaseProtocol
    

    
    init(heroName: Hero,transformation: Transformation, useCase: HeroTransformationUseCaseProtocol) {
        self.heroName = heroName
        self.transformation = transformation
        self.useCase = useCase
    }
    
    func load() {
        useCase.loadTransformation(id: heroName.id, transformation: transformation.id) { [weak self] result in
            switch result {
            case .success(let transformation):
                self?.transformation = transformation
                self?.status.value = .success
            case .failure(let error):
                self?.status.value = .error(reason: error.description)
            }
        }
    
    }
    
}




