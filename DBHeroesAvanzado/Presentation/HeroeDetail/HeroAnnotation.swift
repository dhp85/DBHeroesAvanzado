//
//  HeroAnnotation.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//

import MapKit

/// Clase que representa una anotación de héroe en un mapa, conforme al protocolo MKAnnotation.
final class HeroAnnotation: NSObject, MKAnnotation {

    /// Título de la anotación, que se mostrará en el mapa.
    var title: String?
    
    /// Coordenadas geográficas de la anotación.
    var coordinate: CLLocationCoordinate2D
    
    // MARK: - Inicializadores
    
    /// Inicializa una nueva instancia de HeroAnnotation.
    /// - Parameters:
    ///   - title: El título que se mostrará en la anotación.
    ///   - coordinate: Las coordenadas geográficas de la anotación.
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title // Asigna el título proporcionado.
        self.coordinate = coordinate // Asigna las coordenadas proporcionadas.
    }
}
