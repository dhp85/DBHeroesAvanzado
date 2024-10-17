//
//  HeroesCollectionViewController.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 15/10/24.
//

import UIKit

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

enum SectionsHeroes {
    case main
}

class HeroesCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = HeroesColletionViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<SectionsHeroes, Hero>?
    
    init(viewModel: HeroesColletionViewModel = HeroesColletionViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: HeroesCollectionViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bind()
        viewModel.loaddata(filter: nil)
    }
    
    private func bind() {
        viewModel.statusHeroes.bind { [weak self] status in
            switch status {
            case .dataUpdated:
                var snapshot = NSDiffableDataSourceSnapshot<SectionsHeroes, Hero>()
                snapshot.appendSections([.main])
                snapshot.appendItems(self?.viewModel.heroes ?? [], toSection: .main)
                self?.dataSource?.apply(snapshot)
                
            case .error(reason: let reason):
                let alert = UIAlertController(title: "Error", message: reason, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self?.present(alert,animated: true)
            case .none:
                break
            }
        }
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        
        let cellRegister = UICollectionView.CellRegistration<HeroesCollectionViewCell, Hero>(cellNib: UINib(nibName:HeroesCollectionViewCell.identifier, bundle: nil)) { cell, indexPath, hero in
            if let hero = self.viewModel.heroAt(index: indexPath.row) {
                cell.nameHeroUILabel.text = hero.name
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, hero in
            collectionView.dequeueConfiguredReusableCell(using: cellRegister, for: indexPath, item: hero)
        })
    }
    
}

extension HeroesCollectionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 80)
    }
}
