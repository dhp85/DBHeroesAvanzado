//
//  HeroeDetailViewController.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//

import UIKit

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
        self.status.value = .locationUpdated
    }
}





final class HeroeDetailViewController: UIViewController {
    
    private let viewModel: HeroDetailViewModel
    
    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroeDetailView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadData()
    }
}
