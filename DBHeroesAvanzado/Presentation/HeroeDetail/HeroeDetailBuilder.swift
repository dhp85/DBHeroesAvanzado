//
//  HeroeDetailBuilder.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//

import UIKit

final class HeroeDetailBuilder {
    
    private let name: Hero
    private let heroeUseCase: HeroDetailUseCase
    private let viewModel: HeroDetailViewModel
    
    init(name: Hero) {
        self.name = name
        self.heroeUseCase = HeroDetailUseCase()
        self.viewModel = HeroDetailViewModel(hero: name, useCase: heroeUseCase)
    }
    
    func build() -> UIViewController {
        let viewController = HeroeDetailViewController(viewModel: viewModel)
        return viewController
    }
    
}
