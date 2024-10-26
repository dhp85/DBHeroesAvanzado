//
//  HeroesCollectionBuilder.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 21/10/24.
//
import UIKit

/// Clase responsable de construir y configurar el controlador de vista de la colección de héroes.
final class HeroesCollectionBuilder {
    
    /// Crea y configura un controlador de vista para la colección de héroes.
    /// - Returns: Un `UIViewController` que contiene la colección de héroes, envuelto en un `UINavigationController`.
    func build() -> UIViewController {
        let useCase = HeroesUseCase() // Inicializa el caso de uso para gestionar héroes.
        let viewModel = HeroesColletionViewModel(useCase: useCase) // Crea el ViewModel con el caso de uso.
        let viewController = HeroesCollectionViewController(viewModel: viewModel) // Inicializa el controlador de vista con el ViewModel.
        
        // Crea un UINavigationController con el controlador de vista como controlador raíz.
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen // Configura la presentación modal del controlador de navegación.
        
        return navigationController // Retorna el controlador de navegación configurado.
    }
}
