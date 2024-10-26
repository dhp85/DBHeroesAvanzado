//
//  HeroeDetailBuilder.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//

import UIKit

/// Clase responsable de construir y configurar un controlador de vista para los detalles de un héroe.
/// Utiliza el patrón de diseño Builder para crear una instancia de `HeroeDetailViewController`.
final class HeroeDetailBuilder {
    
    /// Héroe cuyas propiedades se mostrarán en la vista de detalles.
    private let name: Hero
    
    /// Caso de uso para la obtención de detalles del héroe.
    private let heroeUseCase: HeroDetailUseCase
    
    /// ViewModel asociado al héroe, que gestiona la lógica de presentación y los datos de la vista.
    private let viewModel: HeroDetailViewModel
    
    /// Inicializa una nueva instancia de `HeroeDetailBuilder` con un héroe específico.
    /// - Parameter name: El héroe cuyas propiedades se mostrarán en la vista de detalles.
    init(name: Hero) {
        self.name = name
        self.heroeUseCase = HeroDetailUseCase()
        self.viewModel = HeroDetailViewModel(hero: name, useCase: heroeUseCase)
    }
    
    /// Construye y devuelve un controlador de vista configurado para mostrar los detalles del héroe.
    /// - Returns: Una instancia de `UIViewController` configurada para mostrar los detalles del héroe.
    func build() -> UIViewController {
        let viewController = HeroeDetailViewController(viewModel: viewModel)
        return viewController
    }
}
