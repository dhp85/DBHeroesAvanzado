//
//  HeroTransformatinBuilder.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 25/10/24.
//

import UIKit

final class HeroTransformatinBuilder {
    
    private let hero: Hero
    private let transformation: Transformation
    private let heroTransformationUseCase: HeroTransformationUseCase
    private let viewModel: HeroTransformationViewModel
    
    init(hero: Hero,transformation: Transformation) {

        self.hero = hero
        self.transformation = transformation
        self.heroTransformationUseCase = HeroTransformationUseCase()
        self.viewModel = HeroTransformationViewModel(heroName: hero, transformation: transformation, useCase: heroTransformationUseCase)
    }
    
    func build() -> UIViewController {
       let viewController = HeroTransformationViewController(viewModel: viewModel)
        return viewController
    }
    
}
