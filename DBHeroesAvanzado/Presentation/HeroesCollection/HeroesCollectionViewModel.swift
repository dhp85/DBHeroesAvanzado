//
//  HeroesCollectionViewModel.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 21/10/24.
//

import Foundation

enum StatusHeroes {
    case dataUpdated
    case error(reason: String)
    case none
}

final class HeroesColletionViewModel {
    
    let useCase: HeroesUseCaseProtocol
    var statusHeroes: Binding<StatusHeroes> = Binding(.none)
    var heroes: [Hero] = []
    
    init(useCase: HeroesUseCaseProtocol = HeroesUseCase()) {
        self.useCase = useCase
    }
    
    func loaddata(filter: String?) {
        var predicate: NSPredicate?
        if let filter {
            predicate = NSPredicate(format: "name CONTAINS[cd] %@", filter)
            //"name CONTAINS[cd] %@" lo de cd quiere decir c para que trate lo mismos a nombres que empiezan por mayusculas y la d es para las string con simbolos como acentos,etc..
        }
        useCase.loadHeros(filter: predicate) { [weak self] result in
            switch result {
            case .success(let heroes):
                self?.heroes = heroes
                self?.statusHeroes.value = .dataUpdated
            case .failure(let error):
                self?.statusHeroes.value = .error(reason: error.description)
            }
        }
    }
    
    func heroAt(index: Int) -> Hero? {
        guard index < heroes.count else {
            return nil
        }
        return heroes[index]
    }
}
