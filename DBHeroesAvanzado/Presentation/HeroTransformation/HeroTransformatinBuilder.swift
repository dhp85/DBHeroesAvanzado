//
//  HeroTransformatinBuilder.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 25/10/24.
//

import UIKit

/// Clase responsable de construir la vista de transformación de un héroe.
final class HeroTransformationBuilder {
    
    /// La transformación del héroe que se utilizará para construir la vista.
    private(set) var transformation: Transformation
    
    /// Inicializador de la clase HeroTransformationBuilder.
    /// - Parameter transformation: La transformación del héroe que se va a mostrar.
    init(transformation: Transformation) {
        self.transformation = transformation
    }
    
    /// Método para construir y devolver el controlador de vista de transformación de héroe.
    /// - Returns: Una instancia de UIViewController configurada con el ViewModel de transformación.
    func build() -> UIViewController {
        let viewModel = HeroTransformationViewModel(transformation: transformation) // Crea el ViewModel con la transformación proporcionada
        return HeroTransformationViewController(viewModel: viewModel) // Devuelve el controlador de vista configurado
    }
}
