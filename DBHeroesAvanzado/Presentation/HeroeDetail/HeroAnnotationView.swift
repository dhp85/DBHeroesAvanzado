//
//  HeroAnnotationView.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//

import MapKit

/// Clase personalizada de vista de anotación que se utiliza para mostrar anotaciones de héroes en un mapa.
final class HeroAnnotationView: MKAnnotationView {
    
    /// Identificador estático para reutilizar la vista de anotación.
    static var identifier: String {
        return String(describing: HeroAnnotation.self) // Devuelve el nombre de la clase HeroAnnotation como identificador.
    }
    
    // MARK: - Inicializadores
    
    /// Inicializa una nueva vista de anotación.
    /// - Parameters:
    ///   - annotation: La anotación que esta vista representará.
    ///   - reuseIdentifier: Identificador para la reutilización de la vista.
    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // Configura el marco y la posición de la vista de anotación.
        self.frame = CGRect(x: 0, y: 0, width: 40, height: 40) // Tamaño fijo para la vista de anotación.
        self.centerOffset = CGPoint(x: 0, y: -frame.size.height / 2) // Centra la anotación en la ubicación.
        self.canShowCallout = true // Permite mostrar una llamada de información.
        
        setupView() // Configura la vista de anotación.
    }
    
    /// Inicializador requerido que no se implementa.
    /// - Parameter aDecoder: El decodificador utilizado para inicializar la vista.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // Este inicializador no se utiliza.
    }
    
    // MARK: - Métodos Privados
    
    /// Configura la vista de anotación, incluyendo el fondo y la imagen.
    private func setupView() {
        backgroundColor = .clear // Establece el fondo como transparente.
        
        // Crea una imagen de la anotación a partir de un recurso.
        let view = UIImageView(image: UIImage(resource: .bolaDragon))
        addSubview(view) // Añade la imagen como subvista.
        
        view.frame = self.frame // Establece el marco de la imagen para que coincida con la vista de anotación.
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure) // Añade un botón de detalles al lado derecho de la llamada de información.
    }
}
