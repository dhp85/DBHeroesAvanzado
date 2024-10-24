//
//  HeroDetailUseCaseProtocol.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//

import Foundation

protocol HeroDetailUseCaseProtocol {
    
    func loadLocationsForHeroWith(id: String, completion: @escaping ((Result<[Location], APIErrorResponse>) -> Void))
    func loadTransformationsForHeroWith(id: String, completion: @escaping ((Result<[Transformation], APIErrorResponse>)) -> Void)
}


final class HeroDetailUseCase: HeroDetailUseCaseProtocol {
    
    private var apiProvider: APISessionProtocol
    private var StoreData: StoreDataProvider
    
    init(apiProvider: APISessionProtocol = APISession(), StoreData: StoreDataProvider = .shared ) {
        self.apiProvider = apiProvider
        self.StoreData = StoreData
    }
    
    // Obtener el heroe de la BBDD.
    // Con el heroe comprobamos si tiene localizaciones.
    // Si las tiene las devolvemos.
    // Si no las tiene llamamos a la api, insertamos en BBDD y las devolvemos.
    func loadLocationsForHeroWith(id: String, completion: @escaping (Result<[Location], APIErrorResponse>) -> Void) {
        guard let hero = self.getHeroWith(id: id) else {
            completion(.failure(.heroNotFound(idHero: id)))
            return
        }
        let bdLocations = hero.locations ?? []
        
        if bdLocations.isEmpty {
            apiProvider.loadLocations(id: id) { [weak self] result in
                switch result {
                case .success(let locations):
                    self?.StoreData.addLocation(locations: locations)
                    let bdLocations = hero.locations ?? []
                    let domainLocations = bdLocations.map({Location(moLocation: $0)})
                    completion(.success(domainLocations))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        } else {
            let domainLocations = bdLocations.map({Location(moLocation: $0)})
            completion(.success(domainLocations))
        }
    }
    private func getHeroWith(id: String) -> MOHero? {
        let predicate = NSPredicate(format: "id == %@", id)
        let heroes = StoreData.fetchHeroes(filter: predicate)
        return heroes.first
    }
    
    func loadTransformationsForHeroWith(id: String, completion: @escaping (Result<[Transformation], APIErrorResponse>) -> Void) {
        // Intentar obtener el héroe localmente
        guard let transformation = self.getHeroWith(id: id) else {
            // Si no se encuentra el héroe, devolver un error de "Héroe no encontrado"
            completion(.failure(.heroNotFound(idHero: id)))
            return
        }

        // Intentar obtener las transformaciones almacenadas en local
        let bdTransformations = transformation.transformations ?? []
        print("Transformaciones encontradas en local \(bdTransformations)")

        // Si hay transformaciones en local, las devolvemos directamente
        if bdTransformations.isEmpty {
                apiProvider.loadtransformation(id: id) { [weak self]result in
                    switch result {
                    case .success(let transformations):
                        // Guardar las transformaciones obtenidas de la API en el almacenamiento local
                        self?.StoreData.addTransformation(transformations: transformations)
                        
                        // Volver a obtener las transformaciones desde el héroe actualizado
                        let bdtransformations = transformation.transformations ?? []
                        
                        // Convertir las transformaciones a su formato de dominio y devolverlas
                        let domainTransformations = bdtransformations.map({ Transformation(moTransformation: $0) })
                        completion(.success(domainTransformations))
                        
                        
                    case .failure(let error):
                        // Si hay un error al cargar desde la API, devolver el error
                        completion(.failure(error))
                    }
                }
            
        } else {
            
            let domainTransformations = bdTransformations.map({ Transformation(moTransformation: $0) })
            completion(.success(domainTransformations))

        }
    }
    
   /* func loadTransformationsForHeroWith(id: String, completion: @escaping (Result<[Transformation], APIErrorResponse>) -> Void) {
        guard let transformation = self.getHeroWith(id: id) else {
            completion(.failure(.heroNotFound(idHero: id)))
            return
        }
        let bdTransformations = transformation.transformations ?? []
        if bdTransformations.isEmpty {
            apiProvider.loadtransformation(id: id) { result in
                switch result {
                case .success(let transformations):
                    self.StoreData.addTransformation(transformations: transformations)
                    let bdtransformations = transformation.transformations ?? []
                    let domainTransformations = bdtransformations.map({Transformation(moTransformation: $0)})
                    completion(.success(domainTransformations))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }*/
}


    


