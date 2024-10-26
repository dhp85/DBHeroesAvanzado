//
//  HeroesCollectionViewModel.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 21/10/24.
//

import Foundation

/// Enumeración que representa los posibles estados de los héroes.
enum StatusHeroes {
    case dataUpdated // Indica que los datos de los héroes han sido actualizados.
    case error(reason: String) // Indica que ha ocurrido un error, con un mensaje de razón.
    case none // Indica que no hay estado específico.
}

/// ViewModel para gestionar la colección de héroes.
final class HeroesColletionViewModel {
    
    let useCase: HeroesUseCaseProtocol // Protocolo que define el caso de uso para gestionar héroes.
    var statusHeroes: Binding<StatusHeroes> = Binding(.none) // Vinculación del estado de los héroes.
    var heroes: [Hero] = [] // Arreglo que contiene la lista de héroes.
    
    // MARK: - Inicializador
    
    /// Inicializa un nuevo ViewModel para la colección de héroes.
    /// - Parameter useCase: Caso de uso para la carga de héroes. Por defecto, se inicializa con `HeroesUseCase()`.
    init(useCase: HeroesUseCaseProtocol = HeroesUseCase()) {
        self.useCase = useCase // Asigna el caso de uso proporcionado.
    }
    
    // MARK: - Métodos

    /// Carga los datos de héroes, aplicando un filtro opcional.
    /// - Parameter filter: Cadena que representa el criterio de filtro para los nombres de los héroes.
    func loaddata(filter: String?) {
        var predicate: NSPredicate? // Predicado para filtrar héroes por nombre.
        
        if let filter {
            // Crea un predicado que verifica si el nombre del héroe contiene la cadena de filtro, ignorando mayúsculas y caracteres especiales.
            predicate = NSPredicate(format: "name CONTAINS[cd] %@", filter)
            // "cd" significa que es un filtro que ignora el caso y los acentos.
        }
        
        // Llama al caso de uso para cargar los héroes, pasando el predicado de filtro.
        useCase.loadHeros(filter: predicate) { [weak self] result in
            switch result {
            case .success(let heroes):
                self?.heroes = heroes // Actualiza la lista de héroes.
                self?.statusHeroes.value = .dataUpdated // Actualiza el estado a 'dataUpdated'.
            case .failure(let error):
                self?.statusHeroes.value = .error(reason: error.description) // Actualiza el estado a 'error' con la razón del fallo.
            }
        }
    }
    
    /// Obtiene un héroe en una posición específica del arreglo de héroes.
    /// - Parameter index: Índice del héroe en el arreglo.
    /// - Returns: Un héroe si el índice es válido, o `nil` si no lo es.
    func heroAt(index: Int) -> Hero? {
        guard index < heroes.count else {
            return nil // Retorna nil si el índice está fuera de rango.
        }
        return heroes[index] // Retorna el héroe en el índice especificado.
    }
}
