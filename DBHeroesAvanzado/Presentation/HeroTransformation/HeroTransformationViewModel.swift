//
//  HeroTransformationViewModel.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 25/10/24.
//

import Foundation

/// Enumeración que representa los posibles estados de la transformación de un héroe.
enum HeroTransformationState {
    case none          // Estado inicial, no se ha realizado ninguna acción.
    case success       // Indica que la transformación se ha cargado correctamente.
    case error(reason: String)  // Indica que ha ocurrido un error, con un mensaje descriptivo.
}

/// Clase ViewModel para gestionar la lógica de la transformación de un héroe.
final class HeroTransformationViewModel {
    
    // Usa Binding para hacer que los cambios en status sean observables
    let status: Binding<HeroTransformationState>
    private(set) var transformation: Transformation  // Transformación del héroe

    /// Inicializador de la clase HeroTransformationViewModel.
    /// - Parameter transformation: La transformación del héroe que se va a gestionar.
    init(transformation: Transformation) {
        self.transformation = transformation
        self.status = Binding(.none)  // Establece el estado inicial como 'none'
    }
    
    /// Método para cargar la transformación del héroe y actualizar el estado.
    func load() {
        // Verifica si el nombre de la transformación está vacío
        if transformation.name.isEmpty {
            status.value = .error(reason: "Transformacion Vacia" ) // Actualiza el estado a error si está vacío
        } else {
            status.value = .success // Actualiza el estado a éxito si hay un nombre válido
        }
    }
}

