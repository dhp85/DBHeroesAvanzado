//
//  SplashBuilder.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 18/10/24.
//

import UIKit

/// Clase responsable de construir el controlador de vista de la pantalla de presentación (Splash Screen).
final class SplashBuilder {
    
    /// Método que construye y configura el controlador de vista de la pantalla de presentación.
    /// - Returns: Un objeto `UIViewController` configurado para la pantalla de presentación.
    func build() -> UIViewController {
        let viewModel = SplashViewModel()
        return SplashViewController(viewModel: viewModel)
    }
}
