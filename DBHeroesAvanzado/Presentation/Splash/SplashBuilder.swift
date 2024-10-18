//
//  SplashBuilder.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 18/10/24.
//

import UIKit

final class SplashBuilder {
    func build() -> UIViewController {
        let viewModel = SplashViewModel()
        return SplashViewController(viewModel: viewModel)
    }
}
