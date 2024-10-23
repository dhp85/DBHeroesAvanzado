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
        title = "Heroes"
        configureCollectionView()
        bind()
        viewModel.loaddata(filter: nil)
        configureLogoutButton()
        

    }

    
    private func configureLogoutButton() {
        let logoutImage = UIImage(systemName: "escape")
        let logoutButton = UIBarButtonItem(image: logoutImage, style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc func logoutTapped() {
        let loginVC = LoginBuilder().build()
        SecureDataStore.shared.deleteToken()
        StoreDataProvider().clearBBDD()
        self.present(loginVC, animated: true)
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
            cell.nameHeroUILabel.text = hero.name
            cell.heroImageView.setImage(url: hero.photo)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, hero in
            collectionView.dequeueConfiguredReusableCell(using: cellRegister, for: indexPath, item: hero)
        })
    }
    
}

extension HeroesCollectionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hero = viewModel.heroAt(index: indexPath.row) else {
            return
        }
        let viewModel = HeroDetailViewModel(hero: hero)
        let heroDetailVC = HeroeDetailViewController(viewModel: viewModel)
        self.show(heroDetailVC, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 185, height: 180)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Espaciado vertical entre filas
    }
}


