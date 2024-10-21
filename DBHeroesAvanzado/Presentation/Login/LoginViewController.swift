//
//  LoginViewController.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 16/10/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6InByaXZhdGUifQ.eyJpZGVudGlmeSI6IkZCRjlCRTNGLTZDODAtNDYxQi05QUUwLUMwNTE5QjQ4RjFGNyIsImVtYWlsIjoiZGllZ29ocDg1QGdtYWlsLmNvbSIsImV4cGlyYXRpb24iOjY0MDkyMjExMjAwfQ.5WUS4Xh7D7CqYW1QhfY9JQ5DyjECKGNqkyVDwbFX8LE"

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
