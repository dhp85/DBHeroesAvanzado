//
//  LoginViewController.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 16/10/24.
//

import UIKit

/// Controlador de vista para manejar la interfaz de usuario del inicio de sesión.
class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var userNameField: UITextField! // Campo de texto para el nombre de usuario.
    @IBOutlet weak var passwordField: UITextField! // Campo de texto para la contraseña.
    @IBOutlet weak var label: UILabel! // Etiqueta para mostrar mensajes de error o información.
    @IBOutlet weak var spinner: UIActivityIndicatorView! // Indicador de actividad para mostrar carga.
    @IBOutlet weak var signingButton: UIButton! // Botón para iniciar sesión.

    // MARK: - Propiedades Privadas
    
    private let viewModel: LoginViewModel // Instancia del ViewModel para manejar la lógica de inicio de sesión.
    
    // MARK: - Inicializadores
    
    /// Inicializa el controlador de vista con un ViewModel específico.
    /// - Parameter viewModel: El ViewModel que contiene la lógica de inicio de sesión.
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LoginView", bundle: Bundle(for: type(of: self)))
    }
    
    /// Inicializador requerido para decodificación desde Interface Builder.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Ciclo de Vida de la Vista
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind() // Establece el enlace entre la vista y el ViewModel.
        
        // Ejemplo de usuario y contraseña predefinidos para pruebas.
        
    }
    
    // MARK: - Binding Method
    
    /// Establece el enlace entre el ViewModel y la vista para manejar los cambios de estado.
    private func bind() {
        viewModel.onStateChange.bind { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .success:
                self.renderSuccess() // Llama a la función para renderizar el estado de éxito.
                self.present(HeroesCollectionBuilder().build(), animated: true) // Presenta la lista de héroes.
            case .error(reason: let reason):
                self.renderError(reason) // Llama a la función para renderizar el estado de error.
            case .loading:
                self.renderLoading() // Llama a la función para renderizar el estado de carga.
            case .none:
                break // No se requiere acción para el estado 'none'.
            }
        }
    }
    
    // MARK: - State Rendering Functions
    
    /// Renderiza la interfaz de usuario en caso de éxito en el inicio de sesión.
    private func renderSuccess() {
        signingButton.isHidden = false // Muestra el botón de inicio de sesión.
        spinner.stopAnimating() // Detiene el indicador de actividad.
        label.isHidden = true // Oculta la etiqueta de mensajes.
    }
    
    /// Renderiza la interfaz de usuario en caso de error con un mensaje específico.
    /// - Parameter reason: El mensaje de error que se mostrará al usuario.
    private func renderError(_ reason: String) {
        signingButton.isHidden = false // Muestra el botón de inicio de sesión.
        spinner.stopAnimating() // Detiene el indicador de actividad.
        label.isHidden = false // Muestra la etiqueta de mensajes.
        label.text = reason // Muestra el mensaje de error en la etiqueta.
    }
    
    /// Renderiza la interfaz de usuario en caso de que el inicio de sesión esté en progreso.
    private func renderLoading() {
        signingButton.isHidden = true // Oculta el botón de inicio de sesión.
        spinner.startAnimating() // Inicia el indicador de actividad.
        label.isHidden = true // Oculta la etiqueta de mensajes.
    }
    
    // MARK: - Actions
    
    /// Acción del botón de inicio de sesión.
    /// - Parameter sender: El objeto que envía la acción.
    @IBAction func onLoginButton(_ sender: Any) {
        guard let username = userNameField.text, !username.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            renderError("Por favor ingrese un correo electrónico y una contraseña válidos.")
            return
        }
        viewModel.signIn(user: username, password: password) // Llama al método de inicio de sesión en el ViewModel.
    }
}
