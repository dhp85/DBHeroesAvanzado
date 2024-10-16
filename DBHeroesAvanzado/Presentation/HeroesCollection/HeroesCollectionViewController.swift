//
//  HeroesCollectionViewController.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 15/10/24.
//

import UIKit

final class HeroesColletionViewModel {
    
    let useCase: HeroesUseCaseProtocol
    init(useCase: HeroesUseCaseProtocol = HeroesUseCase()) {
        self.useCase = useCase
    }
}

class HeroesCollectionViewController: UIViewController {
    
    private var viewModel = HeroesColletionViewModel()
    
    init(viewModel: HeroesColletionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: HeroesCollectionViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
