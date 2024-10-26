//
//  HeroTransformationViewController.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 25/10/24.
//

import UIKit

/// Controlador de vista para mostrar los detalles de la transformación de un héroe.
final class HeroTransformationViewController: UIViewController {
    
    /// Etiqueta para mostrar el nombre del héroe.
    @IBOutlet weak var nameHero: UILabel!
    
    /// Etiqueta para mostrar la descripción de la transformación del héroe.
    @IBOutlet weak var descriptionHero: UILabel!
    
    /// Imagen de la transformación del héroe.
    @IBOutlet weak var imageTransformation: UIImageView!
    
    /// Modelo de vista asociado al controlador, responsable de gestionar la lógica de la interfaz.
    private let viewModel: HeroTransformationViewModel
    
    /// Inicializador para el controlador de vista, que recibe un modelo de vista.
    /// - Parameter viewModel: El modelo de vista que proporciona la información de transformación del héroe.
    init(viewModel: HeroTransformationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroeTransformationView", bundle: Bundle(for: type(of: self)))
    }
    
    /// Inicializador requerido para la deserialización del controlador de vista.
    /// - Parameter coder: Un objeto NSCoder que permite la deserialización.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Método que se llama cuando la vista ha sido cargada en memoria.
    override func viewDidLoad() {
        super.viewDidLoad()
        bind() // Configura el binding al cargar la vista
        viewModel.load() // Ejecuta la función load() para iniciar el proceso de carga
    }
    
    /// Configura el binding del estado del ViewModel al controlador de vista.
    private func bind() {
        // Vincula el estado del ViewModel al controlador de vista
        viewModel.status.bind { [weak self] state in
            self?.handleStateChange(state)
        }
    }
    
    /// Maneja los cambios en el estado del ViewModel.
    /// - Parameter state: El estado actual de la transformación del héroe.
    private func handleStateChange(_ state: HeroTransformationState) {
        switch state {
        case .none:
            break
        case .success:
            configureView() // Actualiza la interfaz en caso de éxito
        case .error(let reason):
            let alert = UIAlertController(title: "Error", message: reason, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
            // Aquí puedes mostrar un mensaje de error en la interfaz, por ejemplo
        }
    }
    
    /// Configura la interfaz de usuario con los datos del modelo de vista.
    private func configureView() {
        nameHero.text = viewModel.transformation.name
        descriptionHero.text = viewModel.transformation.info
        imageTransformation.setImage(url: viewModel.transformation.photo)
    }
}
