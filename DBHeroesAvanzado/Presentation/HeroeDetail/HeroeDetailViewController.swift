//
//  HeroeDetailViewController.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//

import MapKit

final class HeroeDetailViewController: UIViewController {
    @IBOutlet weak var nameHeroUILabel: UILabel!
    @IBOutlet weak var collectionTransformations: UICollectionView!
    @IBOutlet weak var descriptionHeroUILabel: UILabel!
    @IBOutlet weak var imageMap: MKMapView!
    
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
        bind()
        viewModel.loadData()
    }
    
    func bind() {
        viewModel.status.bind { [weak self] status in
            switch status {
                
            case .locationUpdated:
                self?.setupMap()
            case .error(reason: let reason):
                let alert = UIAlertController(title: "Error", message: reason, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self?.present(alert,animated: true)
            case .none:
                break
            }
        }
    }
    
    private func setupMap() {
        let oldAnnotations = self.imageMap.annotations
        self.imageMap.removeAnnotations(oldAnnotations)
        self.imageMap.addAnnotations(viewModel.annotations)
        
        if let annotation = viewModel.annotations.first {
            imageMap.region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        }
    }
}
