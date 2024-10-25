//
//  HeroTransformationViewController.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 25/10/24.
//

import UIKit

final class HeroTransformationViewController: UIViewController {
    @IBOutlet weak var nameHero: UILabel!
    @IBOutlet weak var descriptionHero: UILabel!
    @IBOutlet weak var imageTransformation: UIImageView!
    
    private let viewModel: HeroTransformationViewModel
    
    init(viewModel: HeroTransformationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroTransformationView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func bind() {
        viewModel.status.bind {[weak self] status in
            switch status {
                
            case .none:
                break
            case .success:
                self?.configureView()
            case .error(reason: let reason):
                let alert = UIAlertController(title: "Error", message: reason, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self?.present(alert,animated: true)
                
            }
            
        }
        
      
        }
    private func configureView() {
        nameHero.text = viewModel.transformation.name
        descriptionHero.text = viewModel.transformation.name
        imageTransformation.setImage(url: viewModel.transformation.photo)
        
    }
    
}
