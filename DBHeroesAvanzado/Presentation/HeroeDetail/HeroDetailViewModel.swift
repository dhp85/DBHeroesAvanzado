//
//  HeroDetailStatus.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//


import Foundation

enum HeroDetailStatus {
    case locationUpdated
    case error(reason: String)
    case none
}

final class HeroDetailViewModel {
    
    private let hero: Hero
    private var heroLocations: [Location] = []
    private var useCase: HeroDetailUseCaseProtocol
    
    var status: Binding<HeroDetailStatus> = Binding(.none)
    var annotations: [HeroAnnotation] = []
    
    init(hero: Hero, useCase: HeroDetailUseCaseProtocol = HeroDetailUseCase()) {
        self.hero = hero
        self.useCase = useCase
    }
    
    func loadData() {
        loadLocations()
    }
    
    private func loadLocations() {
        useCase.loadLocationsForHeroWith(id: hero.id) { [weak self] result in
            switch result {
                
            case .success(let locations):
                self?.heroLocations = locations
                self?.createAnnotations()
            case .failure(let error):
                self?.status.value = .error(reason: error.description)
            }
        }
    }
    
    private func createAnnotations() {
        self.annotations = []
        heroLocations.forEach { [weak self] location in
            guard let coordinate = location.coordinate else {
                return
            }
            let annotation = HeroAnnotation(title: self?.hero.name, coordinate: coordinate)
            self?.annotations.append(annotation)
        }
        self.status.value = .locationUpdated
    }
}