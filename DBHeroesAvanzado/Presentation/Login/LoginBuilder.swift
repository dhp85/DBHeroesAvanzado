//
//  LoginBuilder.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 21/10/24.
//

import UIKit

final class LoginBuilder{
    
    func build() -> UIViewController {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
