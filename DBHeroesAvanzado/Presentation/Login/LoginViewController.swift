//
//  LoginViewController.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 16/10/24.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    @IBAction func goHeroesTapped(_ sender: Any) {
        
        let heroesViewController = HeroesCollectionViewController()
        let navigationController = UINavigationController(rootViewController: heroesViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
        
    }
}
