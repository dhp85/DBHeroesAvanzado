//
//  HeroesUseCaseProtocol.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 16/10/24.
//

import Foundation

// MARK: - HeroesUseCaseProtocol
/// Protocolo que define el contrato para cargar héroes.
/// - Parameters:
///   - filter: Un `NSPredicate` opcional para filtrar los héroes locales.
///   - completion: Clausura que retorna un `Result` con una lista de héroes (`[Hero]`) o un error (`APIErrorResponse`).
protocol HeroesUseCaseProtocol {
    func loadHeros(filter: NSPredicate?, completion: @escaping (Result<[Hero], APIErrorResponse>) -> Void)
}

// MARK: - HeroesUseCase
/// Implementación del caso de uso que gestiona la carga de héroes, tanto de fuente local como remota.
final class HeroesUseCase: HeroesUseCaseProtocol {

    // MARK: - Properties
    private var apiSession: APISessionProtocol
    private var storeDataProvider: StoreDataProvider
    
    // MARK: - Initializer
    /// Inicializa el `HeroesUseCase` con una sesión de API y un proveedor de datos locales.
    /// - Parameters:
    ///   - APISession: Sesión de API para cargar datos remotos (por defecto, una instancia de `APISession`).
    ///   - storeDataProvider: Proveedor de datos locales (por defecto, una instancia compartida de `StoreDataProvider`).
    init(APISession: APISessionProtocol = APISession(), storeDataProvider: StoreDataProvider = .shared) {
        self.apiSession = APISession
        self.storeDataProvider = storeDataProvider
    }
    
    // MARK: - Methods
    /// Carga héroes de la fuente local o, si no hay datos locales, realiza una llamada a la API para obtenerlos.
    /// - Parameters:
    ///   - filter: Un `NSPredicate` opcional para filtrar los héroes almacenados localmente.
    ///   - completion: Clausura que retorna un `Result` con héroes locales o remotos.
    func loadHeros(filter: NSPredicate? = nil, completion: @escaping (Result<[Hero], APIErrorResponse>) -> Void) {
        // Intentar cargar los héroes de la fuente local
        let localHeroes = storeDataProvider.fetchHeroes(filter: filter)
        
        // Si no hay héroes locales, realiza la llamada a la API
        if localHeroes.isEmpty {
            apiSession.loadHeros(name: "") { [weak self] result in
                switch result {
                case .success(let apiHeros):
                    // Almacenar los héroes obtenidos en el proveedor local
                    self?.storeDataProvider.addhero(heroes: apiHeros)
                    // Intentar recuperar los héroes después de almacenarlos
                    let bdheroes = self?.storeDataProvider.fetchHeroes(filter: filter) ?? []
                    // Mapear los resultados locales a objetos `Hero`
                    let heroe = bdheroes.map({ Hero(moHero: $0)})
                    completion(.success(heroe))
                case .failure(let error):
                    // Manejar el error de la API
                    completion(.failure(error))
                }
            }
        } else {
            // Si hay héroes locales, simplemente mapear y retornar
            let heroes = localHeroes.map({ Hero(moHero: $0) })
            completion(.success(heroes))
        }
    }
}
