//
//  HeroDetailUseCaseProtocol.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//

import Foundation

/// Protocolo que define las operaciones necesarias para gestionar los detalles de un héroe.
protocol HeroDetailUseCaseProtocol {
    
    /// Carga las localizaciones asociadas a un héroe específico.
    /// - Parameters:
    ///   - id: Identificador único del héroe.
    ///   - completion: Closure que se llama con el resultado de la operación, que puede ser una lista de localizaciones o un error.
    func loadLocationsForHeroWith(id: String, completion: @escaping ((Result<[Location], APIErrorResponse>) -> Void))
    
    /// Carga las transformaciones asociadas a un héroe específico.
    /// - Parameters:
    ///   - id: Identificador único del héroe.
    ///   - completion: Closure que se llama con el resultado de la operación, que puede ser una lista de transformaciones o un error.
    func loadTransformationsForHeroWith(id: String, completion: @escaping ((Result<[Transformation], APIErrorResponse>) -> Void))
}

/// Clase que implementa la lógica para cargar y gestionar los detalles de un héroe, incluyendo localizaciones y transformaciones.
final class HeroDetailUseCase: HeroDetailUseCaseProtocol {
    
    /// Proveedor de API utilizado para realizar solicitudes de datos sobre héroes.
    private var apiProvider: APISessionProtocol
    
    /// Proveedor de datos que gestiona el almacenamiento local de héroes, localizaciones y transformaciones.
    private var StoreData: StoreDataProvider
    
    /// Inicializador de la clase HeroDetailUseCase.
    /// - Parameters:
    ///   - apiProvider: Proveedor de API a utilizar (por defecto se utiliza APISession).
    ///   - StoreData: Proveedor de datos a utilizar (por defecto se utiliza el singleton compartido).
    init(apiProvider: APISessionProtocol = APISession(), StoreData: StoreDataProvider = .shared ) {
        self.apiProvider = apiProvider
        self.StoreData = StoreData
    }
    
    /// Carga las localizaciones para un héroe específico.
    /// - Parameters:
    ///   - id: Identificador del héroe.
    ///   - completion: Closure que se llama con el resultado de la operación, que puede ser una lista de localizaciones o un error.
    func loadLocationsForHeroWith(id: String, completion: @escaping (Result<[Location], APIErrorResponse>) -> Void) {
        // Intentar obtener el héroe del almacenamiento local
        guard let hero = self.getHeroWith(id: id) else {
            completion(.failure(.heroNotFound(idHero: id))) // Héroe no encontrado
            return
        }
        
        let bdLocations = hero.locations ?? [] // Obtener las localizaciones almacenadas
        
        // Si no hay localizaciones almacenadas, cargarlas desde la API
        if bdLocations.isEmpty {
            apiProvider.loadLocations(id: id) { [weak self] result in
                switch result {
                case .success(let locations):
                    self?.StoreData.addLocation(locations: locations) // Almacenar las localizaciones obtenidas
                    let bdlocations = hero.locations ?? []
                    let domainLocations = bdlocations.map({ Location(moLocation: $0)}) // Convertir a formato de dominio
                    completion(.success(domainLocations)) // Devolver las localizaciones
                case .failure(let error):
                    completion(.failure(error)) // Devolver error si falla la solicitud
                }
            }
        } else {
            // Si hay localizaciones, convertirlas a formato de dominio y devolverlas
            let domainLocations = bdLocations.map({ Location(moLocation: $0) })
            completion(.success(domainLocations))
        }
    }
    
    /// Recupera el héroe correspondiente al identificador proporcionado.
    /// - Parameter id: Identificador del héroe.
    /// - Returns: El héroe encontrado o nil si no existe.
    private func getHeroWith(id: String) -> MOHero? {
        let predicate = NSPredicate(format: "id == %@", id) // Filtro para buscar el héroe
        let heroes = StoreData.fetchHeroes(filter: predicate) // Recuperar héroes del almacenamiento
        return heroes.first // Retornar el primer héroe encontrado
    }
    
    /// Carga las transformaciones para un héroe específico.
    /// - Parameters:
    ///   - id: Identificador del héroe.
    ///   - completion: Closure que se llama con el resultado de la operación, que puede ser una lista de transformaciones o un error.
    func loadTransformationsForHeroWith(id: String, completion: @escaping (Result<[Transformation], APIErrorResponse>) -> Void) {
        // Intentar obtener el héroe localmente
        guard let transformation = self.getHeroWith(id: id) else {
            completion(.failure(.heroNotFound(idHero: id))) // Héroe no encontrado
            return
        }
        
        // Obtener las transformaciones almacenadas
        let bdTransformations = transformation.transformations ?? []
        
        // Si no hay transformaciones, cargarlas desde la API
        if bdTransformations.isEmpty {
            apiProvider.loadtransformation(id: id) { [weak self] result in
                switch result {
                case .success(let transformations):
                    self?.StoreData.addTransformation(transformations: transformations) // Almacenar transformaciones obtenidas
                    let bdtransformations = transformation.transformations ?? []
                    var domainTransformations = bdtransformations.map({ Transformation(moTransformation: $0) }) // Convertir a formato de dominio
                    domainTransformations.sort { $0.name < $1.name } // Ordenar transformaciones por nombre
                    completion(.success(domainTransformations)) // Devolver transformaciones
                case .failure(let error):
                    completion(.failure(error)) // Devolver error si falla la solicitud
                }
            }
        } else {
            // Si hay transformaciones, convertirlas a formato de dominio y devolverlas
            var domainTransformations = bdTransformations.map({ Transformation(moTransformation: $0) })
            domainTransformations.sort { $0.name < $1.name } // Ordenar transformaciones por nombre
            completion(.success(domainTransformations)) // Devolver transformaciones
        }
    }
}



