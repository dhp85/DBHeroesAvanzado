//
//  HeroesCollectionViewController.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 15/10/24.
//

import UIKit

enum SectionsHeroes {
    case main
}

final class HeroesCollectionViewController: UIViewController {
    
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
    
    //Establecemos el Binding con el ViewModel para ser notificados cuando cambia el estado.
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
                cell.nameHeroUILabel.text = hero.name
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
