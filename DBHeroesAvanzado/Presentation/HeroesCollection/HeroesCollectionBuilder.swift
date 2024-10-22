//
//  HeroesCollectionBuilder.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 21/10/24.
//

import UIKit


final class HeroesCollectionBuilder {
    
    
    func build() -> UIViewController {
        let useCase = HeroesUseCase()
        let viewModel = HeroesColletionViewModel(useCase: useCase)
        let viewController = HeroesCollectionViewController(viewModel: viewModel)
        
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
}
