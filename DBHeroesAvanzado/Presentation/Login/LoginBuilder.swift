//
//  LoginBuilder.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 21/10/24.
//

import UIKit

/// Clase responsable de construir el controlador de vista de inicio de sesión.
final class LoginBuilder {
    
    /// Método que construye y configura el controlador de vista de inicio de sesión.
    /// - Returns: Un objeto `UIViewController` configurado para el inicio de sesión.
    func build() -> UIViewController {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
