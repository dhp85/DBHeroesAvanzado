//
//  HeroDetailUseCaseProtocol.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//

import Foundation

protocol HeroDetailUseCaseProtocol {
    
    func loadLocationsForHeroWith(id: String, completion: @escaping ((Result<[Location], APIErrorResponse>) -> Void))
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
            apiProvider.loadLocations(id: id) { result in
                switch result {
                    case .success(let locations):
                    self.StoreData.addLocation(locations: locations)
                    let bdLocations = hero.locations ?? []
                    let domainLocations = bdLocations.map({Location(moLocation: $0)})
                    completion(.success(domainLocations))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    private func getHeroWith(id: String) -> MOHero? {
        let predicate = NSPredicate(format: "id == %@", id)
        let heroes = StoreData.fetchHeroes(filter: predicate)
        return heroes.first
    }
}


    

