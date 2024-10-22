//
//  LoginViewController.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 16/10/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var signingButton: UIButton!
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LoginView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        userNameField.text = "diegohp85@gmail.com"
        //passwordField.text = "123456"
        
        
    }
    // MARK: - Binding Method
    
    /// Establece el enlace entre el ViewModel y la vista para manejar los cambios de estado.
    private func bind() {
        viewModel.onStateChange.bind { [weak self] state in
            switch state {
            case .success:
                self?.renderSuccess() // Llama a la función para renderizar el estado de éxito.
                self?.present(HeroesCollectionBuilder().build(), animated: true) // Presenta la lista de héroes.
            case .error(reason: let reason):
                self?.renderError(reason) // Llama a la función para renderizar el estado de error.
            case .loading:
                self?.renderLoading() // Llama a la función para renderizar el estado de carga.
            case .none:
                break
            }
        }
    }
    
    // MARK: - State Rendering Functions
    
    /// Renderiza la interfaz de usuario en caso de éxito en el inicio de sesión.
    private func renderSuccess() {
        signingButton.isHidden = false
        spinner.stopAnimating()
        label.isHidden = true
    }
    
    /// Renderiza la interfaz de usuario en caso de error con un mensaje específico.
    private func renderError(_ reason: String) {
        signingButton.isHidden = false
        spinner.stopAnimating()
        label.isHidden = false
        label.text = reason // Muestra el mensaje de error en la etiqueta.
    }
    
    /// Renderiza la interfaz de usuario en caso de que el inicio de sesión esté en progreso.
    private func renderLoading() {
        signingButton.isHidden = true
        spinner.startAnimating()
        label.isHidden = true
    }
    
    
    @IBAction func onLoginButton(_ sender: Any) {
        viewModel.signIn(user: userNameField.text, password: passwordField.text)
    }
}
